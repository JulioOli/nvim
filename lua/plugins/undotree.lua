return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
    },
    init = function()
      -- Configurações do undotree
      -- As configurações são definidas no init para serem carregadas antes do plugin
      _G.vim = _G.vim or {}
      _G.vim.g = _G.vim.g or {}
      
      _G.vim.g.undotree_WindowLayout = 2  -- Layout do undotree (2 é geralmente mais prático)
      _G.vim.g.undotree_SplitWidth = 30   -- Largura da janela do undotree
      _G.vim.g.undotree_DiffpanelHeight = 10  -- Altura do painel de diferenças
      _G.vim.g.undotree_SetFocusWhenToggle = 1  -- Foca no undotree quando abrir
      _G.vim.g.undotree_ShortIndicators = 1  -- Usa indicadores curtos
      _G.vim.g.undotree_HelpLine = 0  -- Oculta a linha de ajuda
      _G.vim.g.undotree_TreeNodeShape = "●"  -- Forma do nó na árvore
    end,
  }
}
