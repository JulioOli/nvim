local plugins = {}

-- Função auxiliar para adicionar módulos de plugins
local function add_plugins(module)
  local success, result = pcall(require, module)
  if success and type(result) == "table" then
    for _, plugin in ipairs(result) do
      table.insert(plugins, plugin)
    end
  end
end

-- Importa todos os módulos de plugins
add_plugins("plugins.ui")
add_plugins("plugins.lsp")
add_plugins("plugins.copilot")
add_plugins("plugins.completion")
add_plugins("plugins.treesitter")
add_plugins("plugins.undotree")

return plugins
