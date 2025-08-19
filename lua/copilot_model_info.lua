-- Script para mostrar informações sobre modelos do Copilot
-- Salve este arquivo em ~/.config/nvim/lua/copilot_model_info.lua

local M = {}

-- Função para mostrar modelos disponíveis no Copilot Chat
function M.show_models()
  local status, copilot_chat = pcall(require, "CopilotChat")
  if not status then
    vim.notify("CopilotChat não está instalado", vim.log.levels.ERROR)
    return
  end
  
  local async = require("plenary.async")
  async.run(function()
    -- Recupera o modelo atual
    local current_model = vim.g.copilot_chat_model or copilot_chat.config.options.model or "desconhecido"
    
    -- Tenta obter a lista de modelos disponíveis
    local models = {}
    pcall(function()
      models = copilot_chat:resolve_model().available_models or {}
    end)
    
    local output = {"Informações de modelos do Copilot Chat:", ""}
    table.insert(output, "Modelo atual: " .. current_model)
    table.insert(output, "")
    
    if #models > 0 then
      table.insert(output, "Modelos disponíveis:")
      for _, model in ipairs(models) do
        local model_name = type(model) == "table" and model.id or tostring(model)
        local marker = model_name == current_model and " ✓" or ""
        table.insert(output, "- " .. model_name .. marker)
      end
    else
      table.insert(output, "Nenhum modelo disponível detectado. Use :CopilotChatModels para ver modelos.")
      table.insert(output, "")
      table.insert(output, "Modelos comuns do Copilot Chat:")
      table.insert(output, "- gpt-4o")
      table.insert(output, "- gemini-1.5-pro")
      table.insert(output, "- claude-3-7-sonnet")
      table.insert(output, "- claude-3-sonnet")
      table.insert(output, "- o3-mini")
      table.insert(output, "- o4-mini")
    end
    
    table.insert(output, "")
    table.insert(output, "Como alterar o modelo:")
    table.insert(output, "1. Comando: :CopilotChatModels")
    table.insert(output, "2. Em chat: $nome-do-modelo seguido da pergunta")
    table.insert(output, "3. Atalho: <leader>cm para ver modelos")
    
    -- Mostrar em uma janela flutuante
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    
    local width = 60
    local height = #output
    local win_opts = {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      style = "minimal",
      border = "rounded",
      title = " Modelos do Copilot Chat ",
    }
    
    local win = vim.api.nvim_open_win(buf, true, win_opts)
    
    -- Definir highlights e opções do buffer
    vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    
    -- Adicionar mapeamento para fechar a janela
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })
  end)
end

return M
