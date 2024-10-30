return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = 'v3.x',
    event = "VeryLazy",
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/nvim-cmp' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        local opts = { noremap = true, silent = true }

        -- Set keymap for buffer
        local keymap = vim.api.nvim_buf_set_keymap

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        -- keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

        -- Diagnostic keymaps
        keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
        -- keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
      end)

      -- (Optional) configure lua language server
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)

      require('lspconfig').marksman.setup {}

      lsp_zero.setup_servers({ 'clangd' })
      lsp_zero.setup_servers({ 'marksman' })

      ---
      -- Autocompletion config
      ---
      local cmp = require('cmp')
      local cmp_format = require('lsp-zero').cmp_format({ details = true })
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        sources = {
          -- {name = 'nvim_lsp'},
          { name = 'buffer' },
          { name = 'path' },
          { name = 'codeium' },
          { name = 'nvim_lsp', max_item_count = 5 },
        },
        --- (Optional) Show source name in completion menu
        formatting = cmp_format,
        mapping = cmp.mapping.preset.insert({
          -- `Enter` key to confirm completion
          ['<CR>'] = cmp.mapping.confirm({ select = false }),

          ['C-Space'] = cmp.mapping.complete(),
          ['C-e'] = cmp.mapping.abort(),

          -- Scroll up and down in the completion documentation
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
        }),
        snippet = {
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end
  },
  {
    "Exafunction/codeium.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      local treesitter = require("nvim-treesitter.configs")

      treesitter.setup({
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
        ensure_installed = {
          "c",
          "cpp",
          "python",
          "markdown",
          "markdown_inline",
          "bash",
          "json",
          "yaml",
          "lua",
          "gitignore",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
