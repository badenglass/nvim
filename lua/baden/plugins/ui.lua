return {
  {
    'nvim-lua/plenary.nvim',
  },
  {
    'goolord/alpha-nvim',
    dependencies = {'echasnovski/mini.icons'},
    config = function ()
        local alpha = require'alpha'
        local dashboard = require'alpha.themes.dashboard'
        local ssh = vim.env.SSH_CONNECTION ~= nil
        local loc = ssh and "remote" or "local"
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
              [[    ]] .. loc,
        }
        local buttons = {
            dashboard.button( 'e', '  New File' , ':ene <BAR> startinsert <CR>'),
            dashboard.button( 'l', '󰒲  Lazy' , ':Lazy<CR>'),
            dashboard.button( 'q', '󰅚  Quit NVIM' , ':qa<CR>'),
        }
        if ssh then
            table.insert(buttons, 1, dashboard.button( 'k', '  Code' , ':cd ~/repos/ciss245 <BAR> edit ~/repos/ciss245/main.cpp <BAR> startinsert <CR>'))
            table.insert(buttons, 3, dashboard.button( 'v', '󰠮  Find a Note' , ':FindNote<CR>'))
            table.insert(buttons, 4, dashboard.button( 't', '  Daily Note' , ':DailyNote<CR>'))
        end

        dashboard.section.buttons.val = buttons

        local handle = io.popen('fortune')
        local fortune = handle:read('*a')
        handle:close()
        dashboard.section.footer.val = fortune

        dashboard.config.opts.noautocmd = true

        alpha.setup(dashboard.config)
    end
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      'echasnovski/mini.icons',
    },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        cmdline = {
          format = {
            search_down = {
              view = 'cmdline',
            },
            search_up = {
              view = 'cmdline',
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
    'shaunsingh/nord.nvim',
    lazy = true,
    -- priority = 1000,
    init = function()
      vim.cmd.colorscheme('nord')
    end,
  },
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_enable_italic = true
      vim.cmd.colorscheme('everforest')
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
 }
