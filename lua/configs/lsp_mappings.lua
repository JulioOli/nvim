-- Mapeia os servidores do Mason para os nomes usados no lspconfig
local M = {}

-- Esta tabela mapeia os nomes dos pacotes Mason para os nomes usados pelo lspconfig
M.server_mappings = {
  ["lua-language-server"] = "lua_ls",
  ["typescript-language-server"] = "tsserver",
  ["bash-language-server"] = "bashls",
  ["html-lsp"] = "html",
  ["css-lsp"] = "cssls",
  ["json-lsp"] = "jsonls",
  -- jdtls é configurado separadamente
}

return M
