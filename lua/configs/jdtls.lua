-- Arquivo de configuração específico para o JDTLS (Java Language Server)
local M = {}

M.setup = function()
  -- Imprime mensagem de debug para verificar se a função está sendo chamada
  print("Iniciando configuração do JDTLS")

  -- Verifica se o plugin nvim-jdtls está instalado
  local has_jdtls, jdtls = pcall(require, "jdtls")
  if not has_jdtls then
    vim.notify("Plugin nvim-jdtls não está instalado", vim.log.levels.ERROR)
    return
  end
  
  -- Verifica se o jdtls está instalado pelo Mason
  local jdtls_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls")
  local jdtls_bin = jdtls_path .. "/bin/jdtls"
  
  if vim.fn.filereadable(jdtls_bin) ~= 1 then
    vim.notify("jdtls não está instalado. Use :MasonInstall jdtls para instalá-lo.", vim.log.levels.ERROR)
    return
  end
  
  -- Detecção automática do projeto Java
  local root_markers = {
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    ".git",
    "mvnw",
    "gradlew",
    "settings.gradle",
    "settings.gradle.kts",
    ".classpath",
    ".project"
  }
  
  local root_dir = jdtls.setup.find_root(root_markers)
  if not root_dir then
    -- Se não encontrar um marcador de projeto, usa o diretório atual
    root_dir = vim.fn.getcwd()
  end
  
  -- Verifica se é um projeto com estrutura plana
  local is_flat_project = false
  local classpath_file = root_dir .. "/.classpath"
  if vim.fn.filereadable(classpath_file) == 1 then
    local content = vim.fn.readfile(classpath_file)
    for _, line in ipairs(content) do
      if line:match('classpathentry%s+kind="src"%s+path=""') then
        is_flat_project = true
        vim.notify("Projeto Java com estrutura plana detectado", vim.log.levels.INFO)
        break
      end
    end
  end
  
  -- Configura o caminho para o workspace do jdtls
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_folder = vim.fn.expand("~/.cache/jdtls/workspace/") .. project_name
  
  -- Cria o diretório do workspace se não existir
  vim.fn.mkdir(workspace_folder, "p")
  
  -- Encontra o path do launcher JAR (necessário para configuração avançada)
  local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher_jar == "" then
    vim.notify("Não foi possível encontrar o launcher JAR do jdtls", vim.log.levels.ERROR)
    return
  end
  
  -- Detecção do sistema operacional para config_os
  local config_os = "config_linux"
  if vim.fn.has("mac") == 1 then
    config_os = "config_mac"
  elseif vim.fn.has("win32") == 1 or vim.fn.has("wsl") == 1 then
    config_os = "config_win"
  end
  
  -- Comando para iniciar o jdtls com configuração avançada
  local cmd = {
    -- Prefira usar a JVM local se existir (para melhor desempenho)
    -- Verificar JDK 17 primeiro, depois JDK 11 ou o padrão
    "java",
    
    -- Configurações para o jdtls
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    
    -- Melhorias para performance
    "-XX:+UseParallelGC",
    "-XX:GCTimeRatio=4",
    "-XX:AdaptiveSizePolicyWeight=90",
    
    -- Verifica se o lombok está disponível e adiciona como agente
    "-jar", launcher_jar,
    
    -- Configuração específica para o OS
    "-configuration", jdtls_path .. "/" .. config_os,
    
    -- Diretório de workspace específico para o projeto
    "-data", workspace_folder,
  }
  
  -- Configurações avançadas para o Java
  local settings = {
    java = {
      -- Configurações específicas para projetos planos
      project = {
        sourcePaths = is_flat_project and {""} or nil,  -- Define o path de fonte como raiz para projetos planos
      -- Configurações de interface e IDE
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      
      -- Melhor suporte à refatoração
      refactoring = {
        extract = {
          interface = { enablePreview = true },
          method = { enablePreview = true },
          constant = { preferredName = "" },
          field = { preferredName = "" },
        },
      },
      
      -- Configurações de completion
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*", 
          "sun.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org",
          ""
        },
      },
      
      -- Configurações para import e organização de código
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      
      -- Configurações de geração de código
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          codeStyle = "STRING_CONCATENATION",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      
      -- Configuração de compilação e JDK
      configuration = {
        updateBuildConfiguration = "interactive",
        maven = {
          downloadSources = true,
        },
        runtimes = {
          -- Adiciona as JDKs disponíveis no sistema (adapte os caminhos conforme necessário)
          {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-openjdk/",
          },
          {
            name = "JavaSE-11",
            path = "/usr/lib/jvm/java-11-openjdk/",
          },
        }
      },
      
      -- Formatação e estilo de código
      format = {
        enabled = true,
        settings = {
          url = jdtls_path .. "/formatter.xml",
        }
      },
      
      -- Configurações de compilação
      compile = {
        nullAnalysis = {
          mode = "automatic"
        }
      },
      
      -- Configurações específicas para Maven
      maven = {
        downloadSources = true,
      },
      
      -- Configurações para importação
      import = {
        maven = {
          enabled = true,
        },
        gradle = {
          enabled = true,
          wrapper = {
            enabled = true,
          },
        },
      },
    },
  }
  
  -- Habilidades estendidas do cliente
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  
  -- Configuração avançada do cliente LSP para Java
  local config = {
    cmd = cmd,
    root_dir = root_dir,
    settings = settings,
    init_options = {
      bundles = {}, -- Para adicionar bundles como DAP (depuração)
      extendedClientCapabilities = extendedClientCapabilities,
    },
    -- Garante que tenha capabilities completas com nvim-cmp
    capabilities = (function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        },
      }
      -- Integração com nvim-cmp se disponível
      local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end
      return capabilities
    end)(),
    
    -- Define on_attach para adicionar keymaps e funcionalidades específicas
    on_attach = function(client, bufnr)
      -- Habilita formatação ao salvar
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function() 
          vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end,
      })
      
      -- Keymappings avançados específicos para Java
      local opts = { noremap = true, silent = true, buffer = bufnr }
      
      -- Keymaps básicos
      vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
      vim.keymap.set("n", "<leader>jt", jdtls.test_class, opts)
      vim.keymap.set("n", "<leader>jn", jdtls.test_nearest_method, opts)
      
      -- Keymaps de refatoração
      vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
      vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, opts)
      vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
      vim.keymap.set("v", "<leader>jc", function() jdtls.extract_constant(true) end, opts)
      vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, opts)
      
      -- Aplicar keymaps padrão do LSP
      local has_zero, lsp_zero = pcall(require, "lsp-zero")
      if has_zero then
        lsp_zero.default_keymaps({ buffer = bufnr })
      else
        -- Keymaps básicos se lsp-zero não estiver disponível
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
      end
      
      -- Notifica que o JDTLS foi inicializado corretamente
      vim.notify("JDTLS inicializado para " .. root_dir, vim.log.levels.INFO)
    end,
  }
  
  -- Inicia o servidor de linguagem Java
  jdtls.start_or_attach(config)
end

-- Removido o autocmd daqui para evitar duplicação com o definido em plugins/java.lua

return M
