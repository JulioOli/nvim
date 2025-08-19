return {
  -- Importa todos os módulos de plugins
  table.unpack(require("plugins.ui")),
  table.unpack(require("plugins.lsp")),
  table.unpack(require("plugins.copilot")),
  table.unpack(require("plugins.completion")),
  table.unpack(require("plugins.treesitter")),
}
