
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary", -- versão mais recente e estável
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- já deve estar instalado
      { "nvim-lua/plenary.nvim" },  -- dependência
    },
    config = function()
      require("CopilotChat").setup({
        show_help = "yes", -- mostra sugestões de comandos
      })
    end,
    cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatExplain" }, -- comandos disponíveis
  }
}
