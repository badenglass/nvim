return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    event = 'VeryLazy',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/nvim-cmp' },
      { 'L3MON4D3/LuaSnip' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        local opts = { noremap = true, silent = true }

        local keymap = vim.api.nvim_buf_set_keymap

        keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

        keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
      end)

      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)

      lsp_zero.setup_servers({ 'clangd' })

      require('lspconfig').marksman.setup {}
      lsp_zero.setup_servers({ 'marksman' })

      local cmp = require('cmp')
      local cmp_format = require('lsp-zero').cmp_format({ details = true })
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        sources = {
          { name = 'buffer' },
          { name = 'path' },
          { name = 'codeium', max_item_count = 1 },
          { name = 'nvim_lsp', max_item_count = 5 },
        },
        formatting = cmp_format,
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['C-y'] = cmp.mapping.complete(),
          ['C-e'] = cmp.mapping.abort(),

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
    'Exafunction/codeium.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup({
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    dependencies = {
      'windwp/nvim-ts-autotag',
    },
    config = function()
      local treesitter = require('nvim-treesitter.configs')

      treesitter.setup({
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
        ensure_installed = {
          'c',
          'cpp',
          'python',
          'markdown',
          'markdown_inline',
          'bash',
          'json',
          'yaml',
          'lua',
          'gitignore',
        },
      })
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({})
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    config = function()
      -- to do
    end,
  },
}
