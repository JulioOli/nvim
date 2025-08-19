return {
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup {
        -- Uma lista de nomes de parsers para manter instalados ou "all"
        ensure_installed = {
          "lua", "vim", "vimdoc", "python", "javascript", "typescript",
          "html", "css", "json", "bash", "markdown", "markdown_inline",
          "java", "c", "cpp",
        },
        
        -- Instalar parsers de forma síncrona (aplica-se apenas a `ensure_installed`)
        sync_install = false,
        
        -- Instalação automática de parsers em tempo real
        auto_install = true,
        
        -- Lista de parsers para ignorar instalar (para "all")
        ignore_install = {},
        
        highlight = {
          enable = true,
          
          -- Desabilitar para arquivos grandes
          disable = function(_, _)
            return false
          end,
          
          -- Definir isso como true vai rodar `:h syntax` e tree-sitter ao mesmo tempo
          additional_vim_regex_highlighting = false,
        },
        
        -- Indent com Tree-sitter
        indent = { enable = true },
        
        -- Incrementar seleção com Tree-sitter
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },
      }
    end,
  },
  
  -- Plugin adicional que fornece boas adições para o treesitter
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automaticamente saltar para o próximo objeto ao final do objeto atual
            keymaps = {
              -- Você pode usar a notação de captura de grupo @... como definida em textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- se os movimentos forem salvos na jump list
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      }
    end,
  }
}
