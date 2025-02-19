--    _               _            _                  _
--   | |__   __ _  __| | ___ _ __ ( )___   _ ____   _(_)_ __ ___
--   | '_ \ / _` |/ _` |/ _ \ '_ \|// __| | '_ \ \ / / | '_ ` _ \
--   | |_) | (_| | (_| |  __/ | | | \__ \ | | | \ V /| | | | | | |
--   |_.__/ \__,_|\__,_|\___|_| |_| |___/ |_| |_|\_/ |_|_| |_| |_|
--     nothing about it is original


--                                                          _   _
--                                               ___  _ __ | |_(_) ___  _ __  ___
--                                              / _ \| '_ \| __| |/ _ \| '_ \/ __|
--                                             | (_) | |_) | |_| | (_) | | | \__ \
--                                              \___/| .__/ \__|_|\___/|_| |_|___/
--                                                   |_|
--                                                                         options
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local opt = vim.opt

opt.relativenumber = true
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.laststatus = 2

opt.wrap = false

opt.autowrite = true;

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.signcolumn = 'yes'

opt.backspace = 'indent,eol,start'

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false

opt.conceallevel = 2

opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

opt.mouse = 'a'
opt.scrolloff = 8

opt.showmode = false

opt.shiftround = true

opt.wildmode = 'longest:full,full'

opt.smoothscroll = true

--                   _                                                      _
--        __ _ _   _| |_ ___   ___ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___
--       / _` | | | | __/ _ \ / __/ _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
--      | (_| | |_| | || (_) | (_| (_) | | | | | | | | | | | (_| | | | | (_| \__ \
--       \__,_|\__,_|\__\___/ \___\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
--                                                                    autocommands


local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup('baden_' .. name, { clear = true })
end

-- highlight on yank
autocmd('TextYankPost', {
  group = augroup('YankHighlight'),
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '100' })
  end
})

-- remove trailing whitespaces
autocmd('BufWritePre', {
  group = augroup('RemoveTrailingSpace'),
  callback = function()
    local curpos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, curpos)
  end
})

-- resize splits if window got resized
autocmd('VimResized', {
  group = augroup('ResizeSplits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- go to last loc when opening a buffer
autocmd('BufReadPost', {
  group = augroup('LastLoc'),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
autocmd('FileType', {
  group = augroup('CloseQ'),
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'help',
    'lspinfo',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- auto create dir when saving a file
autocmd('BufWritePre', {
  group = augroup('AutoCreateDir'),
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

--                                                                          _
--         _   _ ___  ___ _ __ ___ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___
--        | | | / __|/ _ \ '__/ __/ _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
--        | |_| \__ \  __/ | | (_| (_) | | | | | | | | | | | (_| | | | | (_| \__ \
--         \__,_|___/\___|_|  \___\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
--                                                                    usercommands

--                                       _
--                                      | | _____ _   _ _ __ ___   __ _ _ __  ___
--                                      | |/ / _ \ | | | '_ ` _ \ / _` | '_ \/ __|
--                                      |   <  __/ |_| | | | | | | (_| | |_) \__ \
--                                      |_|\_\___|\__, |_| |_| |_|\__,_| .__/|___/
--                                                |___/                |_|
--                                                                         keymaps


local map = vim.keymap.set

map('n', '<leader><esc>', '<cmd>nohl<CR>', { desc = 'clear search hl' })

map('v', '<', '<gv')
map('v', '>', '>gv')

map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

map('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
map('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

--                                                              _
--                                                             | | __ _ _____   _
--                                                             | |/ _` |_  / | | |
--                                                             | | (_| |/ /| |_| |
--                                                             |_|\__,_/___|\__, |
--                                                                          |___/
--                                                                            lazy

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
opt.rtp:prepend(lazypath)

--                                                      _             _
--                                                _ __ | |_   _  __ _(_)_ __  ___
--                                               | '_ \| | | | |/ _` | | '_ \/ __|
--                                               | |_) | | |_| | (_| | | | | \__ \
--                                               | .__/|_|\__,_|\__, |_|_| |_|___/
--                                               |_|            |___/
--                                                                         plugins


require('lazy').setup({
  spec = {
    {
      'navarasu/onedark.nvim',
      lazy = false,
      priority = 1000,
      opts = {
        transparent = true,
        style = 'warmer',
        colors = {},
        highlights = {
          -- ["@keyword"] = {fg = '$green'},
          -- ["@string"] = {fg = '$bright_orange', bg = '#00ff00', fmt = 'bold'},
          -- ["@function"] = {fg = '#0000ff', sp = '$cyan', fmt = 'underline,italic'},
          -- ["@function.builtin"] = {fg = '#0059ff'}
          ["@markup.heading.1.markdown"] = { fg = '$green' },
          ["@markup.heading.2.markdown"] = { fg = '$blue' },
          ["@markup.heading.3.markdown"] = { fg = '$blue' },
          ["@markup.heading.4.markdown"] = { fg = '$blue' },
          ["@markup.heading.5.markdown"] = { fg = '$blue' },
          ["@markup.heading.6.markdown"] = { fg = '$blue' },
          ["NormalFloat"] = { bg = 'NONE' },
          ["FloatBorder"] = { bg = 'NONE' },
          ["FzfLuaBackdrop"] = { bg = 'NONE' },
        },
      },
      config = function(_, opts)
        require('onedark').setup(opts)
        require('onedark').load()
      end,
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
      opts = {
        heading = {
          backgrounds = {
            'NONE',
          },
        },
      },
    },
    {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = {
        preset = 'helix',
        defaults = {},
      },
      dependencies = { 'echasnovski/mini.icons' },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'tadmccorkle/markdown.nvim',
      },
      build = ':TSUpdate',
      config = function()
        local treesitter = require('nvim-treesitter.configs')
        treesitter.setup({
          markdown = { enable = true },
          indent = { enable = true },
          highlight = { enable = true },
          textobjects = {
            select = {
              enabled = true,
            },
          },
          ensure_installed = {
            'html',
            'c',
            'cpp',
            'python',
            'markdown',
            'markdown_inline',
            'bash',
            'json',
            'yaml',
            'lua',
            'swift',
            'gitignore',
          },
        })
      end,
    },
    { 'windwp/nvim-ts-autotag' },
    {
      'echasnovski/mini.ai',
      event = 'VeryLazy',
      dependencies = { 'folke/which-key.nvim' },
      opts = function()
        local ai = require('mini.ai')
        return {
          n_lines = 500,
          custom_textobjects = {
            o = ai.gen_spec.treesitter({
              a = { '@block.outer', '@conditional.outer', '@loop.outer' },
              i = { '@block.inner', '@conditional.inner', '@loop.inner' },
            }),
            f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
            c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
            t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
            d = { '%f[%d]%d+' },
            e = {
              { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
              '^().*()$',
            },
            g = function(ai_type)
              local start_line, end_line = 1, vim.fn.line("$")
              if ai_type == "i" then
                local first_nonblank = vim.fn.nextnonblank(start_line)
                local last_nonblank = vim.fn.prevnonblank(end_line)
                if first_nonblank == 0 or last_nonblank == 0 then
                  return { from = { line = start_line, col = 1 } }
                end
                start_line, end_line = first_nonblank, last_nonblank
              end
              local to_col = math.max(vim.fn.getline(end_line):len(), 1)
              return {
                from = { line = start_line, col = 1 },
                to = { line = end_line, col = to_col }
              }
            end,
            u = ai.gen_spec.function_call(),
            U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
          },
        }
      end,
    },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    {
      'stevearc/conform.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        local conform = require('conform')

        conform.setup({
          formatters_by_ft = {
            javascript = { 'prettier' },
            javascriptreact = { 'prettier' },
            css = { 'prettier' },
            html = { 'prettier' },
            json = { 'prettier' },
            yaml = { 'prettier' },
            markdown = { 'prettier' },
            lua = { 'stylua' },
            python = { 'black' },
          },
          format_on_save = {
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          },
        })

        vim.keymap.set({ "n", "v" }, "<localleader><cr>", function()
          conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          })
        end, { desc = "Format file or range (in visual mode)" })
      end,
    },
    {
      'echasnovski/mini.surround',
      event = 'VeryLazy',
      opts = {
        mappings = {
          add = 'sa',            -- Add surrounding in Normal and Visual modes
          delete = 'sd',         -- Delete surrounding
          find = 'sf',           -- Find surrounding (to the right)
          find_left = 'sF',      -- Find surrounding (to the left)
          highlight = 'sh',      -- Highlight surrounding
          replace = 'sr',        -- Replace surrounding
          update_n_lines = 'sn', -- Update `n_lines`
        },
      },
      config = true,
    },
    {
      'folke/noice.nvim',
      event = 'VeryLazy',
      dependencies = { 'MunifTanjim/nui.nvim' },
      opts = {
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
            search_down = { view = 'cmdline' },
            search_up = { view = 'cmdline' },
          },
        },
        messages = { enabled = false },
        routes = {
          {
            filter = { event = 'lsp' },
            opts = { skip = true },
          },
        },
        views = {
          cmdline_popup = {
            win_options = {
              winhighlight = { FloatBorder = 'DiagnosticInfo' },
            },
          },
        },
      },
    },
    {
      'stevearc/oil.nvim',
      lazy = false,
      dependencies = { 'echasnovski/mini.icons' },
      keys = {
        { '-', '<cmd>Oil --float<cr>', desc = 'Open parent directory' },
      },
      opts = {
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name)
            return vim.startswith(name, '.')
          end,
          is_always_hidden = function()
            return false
          end,
          natural_order = true,
          case_insensitive = false,
        },
        float = {
          max_width = 0.80,
          max_height = 0.85,
          border = "single",              -- Match FzfLua's border
          get_win_title = function(winid) -- Center title in border
            return vim.fn.fnamemodify(require('oil').get_current_dir(), ':~')
          end,
          win_options = {
            winblend = 0,
          },
        },
      },
      config = true,
    },
    {
      'ibhagwan/fzf-lua',
      lazy = false,
      dependencies = { 'echasnovski/mini.icons' },
      keys = {
        { '<C-w>e', '<cmd>FzfLua buffers<cr>',  desc = 'Fzf Buffers' },
        { '<C-w>r', '<cmd>FzfLua oldfiles<cr>', desc = 'Fzf Recents' },
        { '<C-f>',  '<cmd>FzfLua files<cr>',    desc = 'Fzf Files' },
        { '<C-g>',  '<cmd>FzfLua grep<cr>',     desc = 'Fzf Grep' },
        { '<C-k>',  '<cmd>FzfLua builtin<cr>',  desc = 'Fzf Builtin' },
      },
      opts = {
        fzf_colors = {
          ["gutter"] = "-1"
        },
        winopts = {
          height    = 0.85,
          width     = 0.80,
          row       = 0.35,
          col       = 0.50,
          border    = "single",
          title_pos = "left",
          backdrop  = 0,
        }
      },
    },
    {
      'tummetott/unimpaired.nvim',
      event = 'VeryLazy',
      opts = {},
    },
  },
  install = { colorscheme = { 'onedark' } },
  checker = { enabled = true },
})

--                                                                    _
--                                                                   | |___ _ __
--                                                                   | / __| '_ \
--                                                                   | \__ \ |_) |
--                                                                   |_|___/ .__/
--                                                                         |_|
--                                                                 language server

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = function(desc)
      return { buffer = event.buf, desc = desc }
    end

    map('n', '<localleader>f', '<cmd>FzfLua lsp_document_symbols<cr>', opts('find symbol'))
    map('n', '<localleader>k', '<cmd>lua vim.lsp.buf.hover()<cr>', opts('hover documentation'))
    map('n', '<localleader>d', '<cmd>lua vim.lsp.buf.definition()<cr>', opts('definition'))
    map('n', '<localleader>D', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts('declaration'))
    map('n', '<localleader>i', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts('implementation'))
    map('n', '<localleader>t', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts('type definition'))
    map('n', '<localleader>r', '<cmd>lua vim.lsp.buf.references()<cr>', opts('references'))
    map('n', '<localleader>s', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts('signature help'))
    map('n', '<localleader>n', '<cmd>lua vim.lsp.buf.rename()<cr>', opts('rename symbol'))
    map('n', '<localleader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts('code actions'))
  end,
})

require('lspconfig').marksman.setup({})
require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

--                                                            ___ _ __ ___  _ __
--                                                           / __| '_ ` _ \| '_ \
--                                                          | (__| | | | | | |_) |
--                                                           \___|_| |_| |_| .__/
--                                                                         |_|
--                                                                      completion

local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'render-markdown' },
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({}),
})
