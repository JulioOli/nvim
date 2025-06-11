-- Define o caminho do Python provider
local python_path = vim.fn.expand("~/.config/nvim/venv/bin/python3")
if vim.fn.filereadable(python_path) == 1 then
    vim.g.python3_host_prog = python_path
    print("Python path set to: " .. python_path)
else
    print("⚠️ Python path not found: " .. python_path)
end

-- Configuração para sair do modo de terminal com <Esc>
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
