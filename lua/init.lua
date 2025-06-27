-- Configuração mínima do lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configuração DIRETA do Harpoon
require("lazy").setup({
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup()
      -- Mapeamentos básicos
      vim.keymap.set("n", "<leader>a", function() require("harpoon"):list():append() end)
      vim.keymap.set("n", "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end)
    end,
  }
})
