return {
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "goolord/alpha-nvim",
    dependencies = {"echasnovski/mini.icons"},
    config = function ()
        local alpha = require'alpha'
        local dashboard = require'alpha.themes.dashboard'
        dashboard.section.header.val = {
              [[                                             ]],
              [[                                             ]],
              [[                                             ]],
              [[                                             ]],
              [[     a88888b.  a88888b.  a88888b. .d88888b   ]],
              [[    d8'   `88 d8'   `88 d8'   `88 88.    "'  ]],
              [[    88        88        88        `Y88888b.  ]],
              [[    88        88        88              `8b  ]],
              [[    Y8.   .88 Y8.   .88 Y8.   .88 d8'   .8P  ]],
              [[     Y88888P'  Y88888P'  Y88888P'  Y88888P   ]],
              [[                                             ]],
              [[                                             ]],
              [[                                             ]],
        }
        dashboard.section.buttons.val = {
            dashboard.button( "l", "  Code" , ":cd ~/repos/ciss245 <BAR> edit ~/repos/ciss245/main.cpp <BAR> startinsert <CR>"),
            dashboard.button( "e", "  New File" , ":ene <BAR> startinsert <CR>"),
            dashboard.button( "v", "󰠮  Find a Note" , ":FindNote<CR>"),
            dashboard.button( "t", "  Daily Note" , ":DailyNote<CR>"),
            dashboard.button( "l", "󰒲  Lazy" , ":Lazy<CR>"),
            dashboard.button( "q", "󰅚  Quit NVIM" , ":qa<CR>"),
        }
        local handle = io.popen('fortune')
        local fortune = handle:read("*a")
        handle:close()
        dashboard.section.footer.val = fortune

        dashboard.config.opts.noautocmd = true

        vim.cmd[[autocmd User AlphaReady echo 'nice']]

        alpha.setup(dashboard.config)
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        cmdline = {
          format = {
            search_down = {
              view = "cmdline",
            },
            search_up = {
              view = "cmdline",
            },
          },
        },
        messages = {
          enabled = false,
        },
      })
    end,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("nord")
    end,
  },
 }
