
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary", -- versão mais recente e estável
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- já deve estar instalado
      { "nvim-lua/plenary.nvim" },  -- dependência
      { "nvim-telescope/telescope.nvim" }, -- para interfaces de seleção
    },
    config = function()
      local copilot_chat = require("CopilotChat")
      copilot_chat.setup({
        show_help = "yes", -- mostra sugestões de comandos
        window = {
          layout = "float", -- pode ser 'float', 'split', ou 'vsplit'
          relative = "editor",
          width = 0.8, -- 80% da largura da tela
          height = 0.8, -- 80% da altura da tela
          padding_top = 1,
          border = "rounded",
          title = "GitHub Copilot Chat",
          footer = "Press <Enter> to submit, <C-c> to close, <C-u> to scroll up, <C-d> to scroll down",
        },
        mappings = {
          -- Adicione atalhos úteis
          complete = {
            insert = "<C-CR>",
            normal = "<C-CR>",
          },
          close = {
            normal = "q",
          },
          reset = {
            normal = "<C-l>",
          },
          submit_prompt = {
            insert = "<CR>",  -- Enter no modo de inserção
            normal = "<CR>",  -- Enter no modo normal
          },
          accept_diff = {
            insert = "<C-y>",
            normal = "<C-y>",
          },
        },
        prompts = {
          -- Prompts personalizados para consultas comuns
          ExplainCode = {
            prompt = "Explique este código em detalhes:\n$text",
          },
          BugFix = {
            prompt = "Há um bug neste código. Por favor, identifique-o e corrija-o:\n$text",
          },
          Optimize = {
            prompt = "Otimize este código, explicando as melhorias:\n$text",
          },
          Docs = {
            prompt = "Escreva documentação para este código:\n$text",
          },
          Tests = {
            prompt = "Escreva testes unitários para este código:\n$text",
          },
        },
      })

      -- Configurando keymaps para o CopilotChat
      vim.keymap.set("n", "<leader>cc", ":CopilotChatToggle<CR>", { desc = "Copilot Chat: Toggle chat" })
      vim.keymap.set("v", "<leader>cc", ":CopilotChatVisual<CR>", { desc = "Copilot Chat: Ask about selected code" })
      vim.keymap.set("n", "<leader>ce", ":CopilotChatExplain<CR>", { desc = "Copilot Chat: Explain code" })
      vim.keymap.set("n", "<leader>ct", ":CopilotChatTests<CR>", { desc = "Copilot Chat: Generate tests" })
      vim.keymap.set("n", "<leader>cb", ":CopilotChatBugFix<CR>", { desc = "Copilot Chat: Fix bugs" })
      vim.keymap.set("n", "<leader>co", ":CopilotChatOptimize<CR>", { desc = "Copilot Chat: Optimize code" })
      vim.keymap.set("n", "<leader>cd", ":CopilotChatDocs<CR>", { desc = "Copilot Chat: Generate docs" })
    end,
    event = "VeryLazy", -- Carrega o plugin quando o Neovim estiver pronto
    keys = {
      { "<leader>cc", desc = "Toggle Copilot Chat" },
      { "<leader>ce", desc = "Explain code with Copilot" },
    },
  }
}
