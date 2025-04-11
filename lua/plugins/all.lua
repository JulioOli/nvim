return {
  -- Importa todos os módulos de plugins
  unpack(require("plugins.ui")),
  unpack(require("plugins.lsp")),
  unpack(require("plugins.copilot")),
  unpack(require("plugins.completion")),
}
