
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")

      -- Exemplo: configurar o servidor do Lua
      lspconfig.lua_ls.setup({})
    end,
  },
}
