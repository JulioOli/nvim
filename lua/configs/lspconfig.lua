-- Carrega lsp-zero para configurar LSPs
local lsp_zero = require('lsp-zero')
local lspconfig = require('lspconfig')
local lsp_mappings = require('configs.lsp_mappings')

-- Configurações compartilhadas para LSPs
local on_attach = function(client, bufnr)
  -- Keymaps padrão para LSP
  lsp_zero.default_keymaps({buffer = bufnr})
  
  -- Keymaps personalizados adicionais
  local opts = {buffer = bufnr, noremap = true, silent = true}
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
end

-- Capacidades do cliente LSP (suporte a snippets, etc)
local capabilities = lsp_zero.capabilities
if pcall(require, 'cmp_nvim_lsp') then
  capabilities = require('cmp_nvim_lsp').default_capabilities()
end

-- Lista de servidores para configurar via lspconfig
-- Não incluir 'jdtls' aqui, ele será configurado separadamente via nvim-jdtls
local servers = { "html", "cssls", "pyright", "lua_ls", "tsserver", "bashls", "clangd" } -- Não incluir 'jdtls' aqui, ele será configurado separadamente via nvim-jdtls

-- Configura LSPs
for _, server in ipairs(servers) do
  lspconfig[server].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- Não configure jdtls aqui - ele é configurado via nvim-jdtls em configs/jdtls.lua
-- e ativado pelo ftplugin/java.lua

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
