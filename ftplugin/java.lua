-- Este arquivo é carregado automaticamente quando um arquivo Java é aberto
-- Configurações específicas para arquivos Java

-- Detecta se estamos em um projeto Java com estrutura plana
local function is_flat_java_project()
  local cwd = vim.fn.getcwd()
  local classpath_file = cwd .. '/.classpath'
  
  if vim.fn.filereadable(classpath_file) == 1 then
    local content = vim.fn.readfile(classpath_file)
    for _, line in ipairs(content) do
      if line:match('classpathentry%s+kind="src"%s+path=""') then
        return true
      end
    end
  end
  
  return false
end

-- Inicia o servidor JDTLS com configurações adequadas
local ok, jdtls = pcall(require, 'jdtls')
if not ok then
  vim.notify("JDTLS não está instalado. Instalando via Mason...", vim.log.levels.WARN)
  vim.cmd("MasonInstall jdtls")
  return
end

-- Detectar o projeto e configurar o LSP adequadamente
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.expand('~/.cache/jdtls/workspace/') .. project_name

-- Configuração especial para projetos com estrutura plana
local extra_java_opts = {}
if is_flat_java_project() then
  vim.notify("Projeto Java com estrutura plana detectado. Configurando LSP apropriadamente.", vim.log.levels.INFO)
  extra_java_opts = {
    settings = {
      java = {
        project = {
          sourcePaths = {""}  -- Usar a raiz como source path
        }
      }
    }
  }
end

-- Configuração básica para o JDTLS
local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-Xmx2G',
    '-jar', vim.fn.glob(vim.fn.expand('~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')),
    '-configuration', vim.fn.expand('~/.local/share/nvim/mason/packages/jdtls/config_linux'),
    '-data', workspace_dir
  },
  root_dir = vim.fs.dirname(vim.fs.find({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', '.classpath'}, { upward = true })[1]),
  settings = extra_java_opts.settings or {},
}

-- Configurações específicas para Java
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

-- Configurações para compilação e execução de Java
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
end

-- Adiciona keymaps específicos para Java (independente do LSP)
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
end

-- Adiciona keymaps básicos para compilar e executar Java
map('n', '<leader>jc', ':!javac %<CR>', { desc = 'Compilar arquivo Java atual' })
map('n', '<leader>jr', ':!java -cp %:p:h %:t:r<CR>', { desc = 'Executar classe Java atual' })

-- Adiciona keymaps específicos para projetos com estrutura plana
if is_flat_java_project() then
  map('n', '<leader>jca', ':!javac -d bin controller/*.java model/*.java view/*.java<CR>', { desc = 'Compilar todo o projeto Java' })
  map('n', '<leader>jra', ':!java -cp bin MonitorAcoes<CR>', { desc = 'Executar aplicação MonitorAcoes' })
end

-- Inicia o JDTLS
jdtls.start_or_attach(config)

-- Configura keymaps específicos do LSP para Java
vim.cmd [[
  nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
  nnoremap <leader>jv <Cmd>lua require('jdtls').extract_variable()<CR>
  vnoremap <leader>jv <Cmd>lua require('jdtls').extract_variable(true)<CR>
  nnoremap <leader>jc <Cmd>lua require('jdtls').extract_constant()<CR>
  vnoremap <leader>jc <Cmd>lua require('jdtls').extract_constant(true)<CR>
  vnoremap <leader>jm <Cmd>lua require('jdtls').extract_method(true)<CR>
]]
