
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main", -- alterado de 'canary' para 'main' conforme recomendado
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- já deve estar instalado
      { "nvim-lua/plenary.nvim" },  -- dependência
      { "nvim-telescope/telescope.nvim" }, -- para interfaces de seleção
    },
    config = function()
      local copilot_chat = require("CopilotChat")
      copilot_chat.setup({
        show_help = "yes", -- mostra sugestões de comandos
        -- Configuração de modelo padrão
        model = "gpt-4o", -- Você pode escolher um modelo como "gpt-4o", "claude-3-7-sonnet", etc.
        -- Opções: gpt-4o, gemini-1.5-pro, claude-3-sonnet, claude-3-7-sonnet, etc.
        -- Depende das opções disponíveis na sua conta GitHub Copilot
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
          -- Prompts com modelos específicos
          ExplainGPT4 = {
            prompt = "$gpt-4o Explique este código em detalhes:\n$text",
            mapping = "<leader>c4e",
            description = "Explica o código usando GPT-4o",
          },
          ExplainGemini = {
            prompt = "$gemini-1.5-pro Explique este código em detalhes:\n$text",
            mapping = "<leader>cge",
            description = "Explica o código usando Gemini 1.5 Pro",
          },
          ExplainClaude = {
            prompt = "$claude-3-7-sonnet Explique este código em detalhes:\n$text",
            mapping = "<leader>cle",
            description = "Explica o código usando Claude 3.7 Sonnet",
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
      
      -- Atalhos para selecionar modelos
      vim.keymap.set("n", "<leader>cm", ":CopilotChatModels<CR>", { desc = "Copilot Chat: Select model" })
      vim.keymap.set("n", "<leader>cmi", function() require("copilot_model_info").show_models() end, 
                     { desc = "Copilot Chat: Show model info" })
      
      -- Você também pode usar modelos específicos diretamente em prompts:
      -- Exemplo: $gpt-4o Explique este código
      
      -- Adicione atalhos para modelos específicos se desejar
      vim.keymap.set("n", "<leader>c4", function()
        vim.cmd("CopilotChat $gpt-4o " .. vim.fn.input("Pergunta para GPT-4o: "))
      end, { desc = "Copilot Chat: Ask GPT-4o" })
      
      vim.keymap.set("n", "<leader>cg", function()
        vim.cmd("CopilotChat $gemini-1.5-pro " .. vim.fn.input("Pergunta para Gemini: "))
      end, { desc = "Copilot Chat: Ask Gemini" })
      
      vim.keymap.set("n", "<leader>cl", function()
        vim.cmd("CopilotChat $claude-3-7-sonnet " .. vim.fn.input("Pergunta para Claude: "))
      end, { desc = "Copilot Chat: Ask Claude" })
    end,
    event = "VeryLazy", -- Carrega o plugin quando o Neovim estiver pronto
    keys = {
      { "<leader>cc", desc = "Toggle Copilot Chat" },
      { "<leader>ce", desc = "Explain code with Copilot" },
      { "<leader>cm", desc = "Select Copilot model" },
    },
  }
}
