
return {
  {
    'VonHeikemen/lsp-zero.nvim', 
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    opts = {
      ensure_installed = {
        'lua_ls',    -- Lua
        'pyright',   -- Python
        'tsserver',  -- TypeScript/JavaScript
        'html',      -- HTML
        'cssls',     -- CSS
        'jsonls',    -- JSON
        'bashls',    -- Bash
      },
      automatic_installation = true,
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()
      
      -- Configurações gerais para LSPs
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr})
      end)
      
      -- Configuração do language servers
      local lspconfig = require('lspconfig')

      -- Configurações específicas por servidor
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = {'vim', 'require'},
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Configure outros servidores
      lspconfig.pyright.setup({})
      lspconfig.tsserver.setup({})
      lspconfig.html.setup({})
      lspconfig.cssls.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.bashls.setup({})
    end,
  },
}
