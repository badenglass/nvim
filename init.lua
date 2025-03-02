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

-- markdown options
autocmd("FileType", {
  group = augroup("MarkdownSettings"),
  pattern = { "markdown", "md" },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false

    vim.opt_local.wrap = true
    -- vim.opt_local.linebreak = true

    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2

    vim.opt_local.signcolumn = "yes:2"
    vim.opt_local.foldcolumn = "1"
    vim.opt_local.colorcolumn = "0"

    vim.opt_local.list = true
    vim.opt_local.listchars = {
      leadmultispace = "   ",
      lead = " ",
    }

    vim.opt_local.textwidth = 80
    vim.opt_local.wrapmargin = 2
    vim.opt_local.formatoptions = vim.opt_local.formatoptions
        + 'o' -- continue comments
        + 'q' -- allow formatting of comments with gq
        + 'j' -- remove comment leader when joining

    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt_local.foldenable = false
  end,
})

-- markdown front matter

-- Add this right after the MarkdownSettings autocommand, around line 159

-- metadata management for gnosis notes
autocmd('BufWritePre', {
  group = augroup('GnosisMetadata'),
  pattern = vim.fn.expand('~/Documents/gnosis') .. '/*.md',
  callback = function(evt)
    -- Get buffer content
    local lines = vim.api.nvim_buf_get_lines(evt.buf, 0, -1, false)

    -- Check if file already has frontmatter
    local has_frontmatter = false
    local content_start = 1
    if #lines > 0 and lines[1] == '---' then
      for i = 2, #lines do
        if lines[i] == '---' then
          has_frontmatter = true
          content_start = i + 1
          break
        end
      end
    end

    -- Initialize metadata
    local metadata = {
      date = os.date('%Y-%m-%dT%H:%M:%S%z'),
      scratch = 'true'
    }

    -- If frontmatter exists, parse it
    if has_frontmatter then
      for i = 2, content_start - 2 do
        local key, value = lines[i]:match('^([%w_]+):%s*(.+)$')
        if key then
          if key == 'tags' then
            metadata.tags = {}
            for tag in value:gmatch('%w+') do
              table.insert(metadata.tags, tag)
            end
          else
            metadata[key] = value
          end
        end
      end
    end

    -- If scratch is false, prompt for additional metadata
    if metadata.scratch == 'false' then
      if not metadata.title then
        vim.ui.input({
          prompt = 'Title: ',
          default = vim.fn.fnamemodify(evt.file, ':t:r'),
        }, function(input)
          if input then metadata.title = input end
        end)
      end

      if not metadata.tags then
        metadata.tags = { 'none' }
      end

      -- Update modified timestamp
      metadata.modified = os.date('%Y-%m-%dT%H:%M:%S%z')
    end

    -- Format frontmatter
    local frontmatter = { '---' }
    for _, key in ipairs({ 'title', 'date', 'modified', 'tags', 'scratch' }) do
      if metadata[key] then
        if key == 'tags' then
          table.insert(frontmatter, 'tags:')
          for _, tag in ipairs(metadata.tags) do
            table.insert(frontmatter, string.format('  - %s', tag))
          end
        else
          table.insert(frontmatter, string.format('%s: %s', key, metadata[key]))
        end
      end
    end
    table.insert(frontmatter, '---')

    -- Combine frontmatter with content
    local new_lines = vim.list_extend(frontmatter, vim.list_slice(lines, content_start))
    vim.api.nvim_buf_set_lines(evt.buf, 0, -1, false, new_lines)
  end,
})


--                                                                          _
--         _   _ ___  ___ _ __ ___ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___
--        | | | / __|/ _ \ '__/ __/ _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
--        | |_| \__ \  __/ | | (_| (_) | | | | | | | | | | | (_| | | | | (_| \__ \
--         \__,_|___/\___|_|  \___\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
--                                                                    usercommands
--        TODO: daily note & hugo integration

local usercmd = vim.api.nvim_create_user_command

local gnosis_dir = vim.fn.expand('~/Documents/gnosis')
if vim.fn.isdirectory(gnosis_dir) == 0 then
  vim.fn.mkdir(gnosis_dir, 'p')
end

local function create_note(title)
  if not title or title == '' then
    return
  end

  local filename = string.format('%s/%s.md', gnosis_dir, title)
  vim.cmd('edit ' .. filename)

  if vim.fn.filereadable(filename) == 0 then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { '# ' .. title, '' })
  end
end

usercmd('Gnosis', function(opts)
  if opts.args == '' then
    vim.ui.input({
      prompt = 'title: ',
    }, function(input)
      create_note(input)
    end)
  else
    create_note(opts.args)
  end
end, {
  nargs = '?',
  desc = 'new gnosis note',
})

usercmd('G', function(opts)
  vim.cmd('Gnosis ' .. (opts.args or ''))
end, {
  nargs = '?',
  desc = 'Alias for Gnosis command',
})

usercmd('GnosisDaily', function()
  local date = os.date('%d-%m-%y')
  local day = os.date('%a')
  local title = string.format('%s %s %s', day, os.date('%d'), os.date('%b'))

  local filename = string.format('%s/%s.md', gnosis_dir, date)
  vim.cmd('edit ' .. filename)

  if vim.fn.filereadable(filename) == 0 then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { '# ' .. title, '' })
  end
end, {
  desc = 'Create a new daily Gnosis note',
})

usercmd('GD', function()
  vim.cmd('GnosisDaily')
end, {
  desc = 'Alias for GnosisDaily command',
})

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
    --                                                                              _
    --                                                                         _  _(_)
    --                                                                        | || | |
    --                                                                         \_,_|_|
    --                                                                              ui
    {
      "idr4n/github-monochrome.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        ---@type "light"|"dark"|"solarized"|"tokyonight"|"rosepine"|"rosepine-dawn"
        style = "tokyonight",
        alternate_style = "light",
        styles = { floats = "transparent" },
        on_highlights = function(hl, c)
          hl.TreesitterContext = { bg = c.none }

          -- if s == "solarized" then
          --   hl.IblScope = { fg = "#62868C" }
          -- end
        end,
        plugins = {
          ["blink"] = true,
          ["which-key"] = true,
          ["render-markdown"] = true,
          ["mini_icons"] = true,
          ["noice"] = true,
        },
      },
      config = function(_, opts)
        require("github-monochrome").setup(opts)
        vim.cmd.colorscheme("github-monochrome-light")
      end,
    },
    { "typicode/bg.nvim",               lazy = false },
    { "eandrju/cellular-automaton.nvim" },
    { 'echasnovski/mini.tabline',       config = true },
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
    --                                                                              _
    --                                                                     _ __  __| |
    --                                                                    | '  \/ _` |
    --                                                                    |_|_|_\__,_|
    --                                                                        markdown
    {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
      opts = {
        bullet = { icons = { '󰁔', '󰘍' } },
        checkbox = {
          custom = {
            important = { raw = '[~]', rendered = '󰓎 ', highlight = 'DiagnosticWarn' },
          },
        },
        callout = {
          todo = { raw = '[!TODO]', rendered = '󰌶 todo', highlight = 'RenderMarkdownSuccess' },
        },
        heading = {
          backgrounds = { 'NONE' },
        },
        dash = { width = 15 },
      },
    },
    -- { 'kaymmm/bullets.nvim',       ft = "markdown",    config = function() require('Bullets').setup() end, },
    --                                           _                  _ _   _
    --                                          | |_ _ _ ___ ___ __(_) |_| |_ ___ _ _
    --                                          |  _| '_/ -_) -_|_-< |  _|  _/ -_) '_|
    --                                           \__|_| \___\___/__/_|\__|\__\___|_|
    --                                                                      treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-context',
      },
      build = ':TSUpdate',
      config = function()
        local treesitter = require('nvim-treesitter.configs')
        treesitter.setup({
          markdown = { enable = true },
          context = { enabled = true },
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
    --                                                                  _ _
    --                                                       __ ___  __| (_)_ _  __ _
    --                                                      / _/ _ \/ _` | | ' \/ _` |
    --                                                      \__\___/\__,_|_|_||_\__, |
    --                                                                          |___/
    --                                                                          coding
    { 'echasnovski/mini.pairs',    config = true },
    { 'echasnovski/mini.surround', event = 'VeryLazy', config = true, },
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
    --                                                                  __ _ __  _ __
    --                                                                 / _| '  \| '_ \
    --                                                                 \__|_|_|_| .__/
    --                                                                          |_|
    --                                                                      completion
    {
      'saghen/blink.cmp',
      version = '*',
      dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
      opts = {
        snippets = { preset = 'luasnip' },
        keymap = {
          preset = "enter",
          ["<C-y>"] = { "select_and_accept" },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono'
        },
        completion = {
          menu = {
            border = 'single',
          },
          documentation = { window = { border = 'single' } },
        },
        signature = { window = { border = 'single' } },
        cmdline = {
          enabled = false,
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'markdown' },
          providers = {
            markdown = {
              name = 'RenderMarkdown',
              module = 'render-markdown.integ.blink',
              fallbacks = { 'lsp' },
            },
          },
        },
      },
      opts_extend = { "sources.default" }
    },
    --                                                                      _
    --                                                                     | |____ __
    --                                                                     | (_-< '_ \
    --                                                                     |_/__/ .__/
    --                                                                          |_|
    --                                                                language servers
    {
      'neovim/nvim-lspconfig',
      dependencies = { 'saghen/blink.cmp' },
      opts = {
        servers = {
          marksman = {},
          lua_ls = {
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
          }
        }
      },
      config = function(_, opts)
        local lspconfig = require('lspconfig')
        for server, config in pairs(opts.servers) do
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          lspconfig[server].setup(config)
        end

        autocmd('LspAttach', {
          desc = 'LSP actions',
          callback = function(event)
            local desc = function(desc)
              return { buffer = event.buf, desc = desc }
            end

            map('n', '<localleader>f', '<cmd>FzfLua lsp_document_symbols<cr>', desc('find symbol'))
            map('n', '<localleader>k', '<cmd>lua vim.lsp.buf.hover()<cr>', desc('hover documentation'))
            map('n', '<localleader>d', '<cmd>lua vim.lsp.buf.definition()<cr>', desc('definition'))
            map('n', '<localleader>D', '<cmd>lua vim.lsp.buf.declaration()<cr>', desc('declaration'))
            map('n', '<localleader>i', '<cmd>lua vim.lsp.buf.implementation()<cr>', desc('implementation'))
            map('n', '<localleader>t', '<cmd>lua vim.lsp.buf.type_definition()<cr>', desc('type definition'))
            map('n', '<localleader>r', '<cmd>lua vim.lsp.buf.references()<cr>', desc('references'))
            map('n', '<localleader>s', '<cmd>lua vim.lsp.buf.signature_help()<cr>', desc('signature help'))
            map('n', '<localleader>n', '<cmd>lua vim.lsp.buf.rename()<cr>', desc('rename symbol'))
            map({ 'n', 'x' }, '<localleader><cr>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', desc('format'))
            map('n', '<localleader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', desc('code actions'))
          end,
        })
      end
    },
    --                                                                    __      _
    --                                                                   / _|_ __| |_
    --                                                                  |  _| '  \  _|
    --                                                                  |_| |_|_|_\__|
    --                                                                      formatting
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
    --                                                                  _ _  __ ___ __
    --                                                                 | ' \/ _` \ V /
    --                                                                 |_||_\__,_|\_/
    --                                                                      navigation
    --
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
          max_width = 0.60,
          max_height = 0.65,
          border = "single",
          get_win_title = function()
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
        hls = { backdrop = "None" },
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
    --                                                                         _
    --                                                                     ___| |_ __
    --                                                                    / -_)  _/ _|
    --                                                                    \___|\__\__|
    --                                                                            .etc
    {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = {
        preset = 'helix',
        defaults = {},
      },
      dependencies = { 'echasnovski/mini.icons' },
    },
    { 'tummetott/unimpaired.nvim', event = 'VeryLazy', config = true },
  },
  install = { colorscheme = { 'github-monochrome' } },
  checker = { enabled = true },
})

--                                                     _                  _
--                                           ___ _ __ (_)_ __  _ __   ___| |_ ___
--                                          / __| '_ \| | '_ \| '_ \ / _ \ __/ __|
--                                          \__ \ | | | | |_) | |_) |  __/ |_\__ \
--                                          |___/_| |_|_| .__/| .__/ \___|\__|___/
--                                                      |_|   |_|
--                                                                        snippets

local ls = require("luasnip")
ls.config.setup({
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
  update_events = "TextChanged,TextChangedI",
  history = true,
})

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    return "<Tab>"
  end
end, { expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    return "<S-Tab>"
  end
end, { expr = true, silent = true })

autocmd('FileType', {
  group = augroup('MarkdownSnippets'),
  pattern = "markdown",
  callback = function()
    local s = ls.snippet
    local i = ls.insert_node
    local f = ls.function_node
    local fmt = require("luasnip.extras.fmt").fmt

    local function clipboard()
      return vim.fn.getreg("+")
    end

    local markdown_snippets = {
      -- headers
      s("sec", fmt("# {}", { i(1, "section") })),
      s("ssec", fmt("## {}", { i(1, "subsection") })),
      s("sssec", fmt("### {}", { i(1, "subsubsection") })),

      -- paragraphs
      s("par", fmt("\n{}\n", { i(1, "paragraph") })),
      s("spar", fmt("\n{}\n\n", { i(1, "subparagraph") })),

      -- links
      s("link", fmt("[{}]({})", {
        i(1, "text"),
        i(2, "url")
      })),
      s("link daily", fmt("[{}]({}.md)", {
        i(1, "title"),
        f(function() return os.date("%Y-%m-%d") end),
      })),
      s("refl", fmt("[{}][{}]", {
        i(1, "text"),
        i(2, "reference")
      })),

      -- images
      s("img", fmt("![{}]({})", {
        i(1, "alt text"),
        i(2, "image path")
      })),
      s("img clipboard", fmt("![{}]({})", {
        i(1, "alt text"),
        f(clipboard)
      })),

      -- code blocks
      s("cbl", fmt("```{}\n{}\n```", {
        i(1, "language"),
        i(2, "code")
      })),
      s("ilc", fmt("`{}`", {
        i(1, "code")
      })),

      -- text formatting
      s("*", fmt("*{}*", { i(1, "italic text") })),
      s("**", fmt("**{}**", { i(1, "bold text") })),
      s("***", fmt("***{}***", { i(1, "bold italic text") })),

      -- date and time
      s("date", {
        f(function() return os.date("%Y-%m-%d") end),
      }),
      s("time", {
        f(function() return os.date("%H:%M:%S") end),
      }),
      s("datetime", {
        f(function() return os.date("%Y-%m-%d %H:%M:%S") end),
      }),
      s("diso", {
        f(function() return os.date("%Y-%m-%dT%H:%M:%S%z") end),
      }),
    }

    ls.add_snippets("markdown", markdown_snippets)
  end,
})
