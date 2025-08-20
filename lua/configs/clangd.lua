-- Configurações específicas para clangd
local M = {}

-- Função para configurar o clangd
function M.setup()
  local lspconfig = require('lspconfig')
  local lsp_zero = require('lsp-zero')
  
  -- Defina as capacidades que serão usadas pelo clangd
  local capabilities = lsp_zero.capabilities
  if pcall(require, 'cmp_nvim_lsp') then
    capabilities = require('cmp_nvim_lsp').default_capabilities()
  end

  -- Configuração do clangd com opções personalizadas
  lspconfig.clangd.setup {
    on_attach = function(client, bufnr)
      -- Keymaps padrão do LSP
      lsp_zero.default_keymaps({buffer = bufnr})
      
      -- Atalhos específicos para C/C++
      local opts = {buffer = bufnr, noremap = true, silent = true}
      vim.keymap.set('n', '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', opts)
      vim.keymap.set('n', '<leader>cs', '<cmd>ClangdSymbolInfo<cr>', opts)
      vim.keymap.set('n', '<leader>ct', '<cmd>ClangdTypeHierarchy<cr>', opts)
    end,
    capabilities = capabilities,
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--fallback-style=llvm"
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  }
end

return M
