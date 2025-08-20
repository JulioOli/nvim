-- Configurações específicas para Java
return {
  -- Plugin especializado para suporte a Java
  {
    'mfussenegger/nvim-jdtls',
    ft = { "java" },
    dependencies = {
      'neovim/nvim-lspconfig',
      'VonHeikemen/lsp-zero.nvim',
    },
    config = function()
      -- Configura um autocmd para carregar o jdtls quando um arquivo Java for aberto
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          -- Carrega e configura o jdtls
          local ok, jdtls_config = pcall(require, 'configs.jdtls')
          if ok then
            -- Imprime mensagem de debug para verificar se está sendo carregado
            vim.notify("Carregando JDTLS para arquivo Java", vim.log.levels.INFO)
            jdtls_config.setup()
          else
            vim.notify("Erro ao carregar configs.jdtls: " .. tostring(jdtls_config), vim.log.levels.ERROR)
          end
        end,
        group = vim.api.nvim_create_augroup("JavaLSP", { clear = true }),
        desc = "Configura JDTLS para arquivos Java"
      })
    end,
  }
}
