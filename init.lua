-- ~/.config/nvim/init.lua

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      -- Desativa o tema padrão do NvChad
      vim.g.nvchad_theme = nil
    end,
  },

  {
    "Mofiqul/dracula.nvim",
    lazy = false, -- Carrega imediatamente
    priority = 1000, -- Prioridade alta para evitar flicker
    config = function()
      vim.cmd.colorscheme("dracula") -- Aplica o tema
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

-- Carrega os mapeamentos de teclas de forma segura
vim.schedule(function()
  require "mappings"
end)
