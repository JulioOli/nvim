-- Configurações específicas para arquivos C
local status, lspconfig = pcall(require, "lspconfig")
if not status then
  return
end

-- Habilitar clangd com configurações específicas para C
if lspconfig.clangd then
  -- Definir atalhos específicos para arquivos C
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', opts)
  
  -- Outras configurações específicas para C/C++ podem ser adicionadas aqui
  vim.opt_local.tabstop = 4
  vim.opt_local.shiftwidth = 4
  vim.opt_local.expandtab = true
end

-- Se você quiser adicionar atalhos específicos para compilação de C
vim.keymap.set('n', '<F5>', ':w<CR>:!gcc -Wall -o %:r %<CR>', { noremap = true })
vim.keymap.set('n', '<F6>', ':w<CR>:!./%:r<CR>', { noremap = true })

-- Configure as opções do editor para seguir a convenção K&R para C
vim.opt_local.cindent = true
