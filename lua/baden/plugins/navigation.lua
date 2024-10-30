return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")
      local map = vim.keymap.set

      require('telescope').setup{
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<esc>"] = actions.close,
              ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
            },
          },
        },
        pickers = {
          find_files = {
            path_display = { "smart" },
          },
        },
        extensions = {},
      }

      map('n', '<leader>f/', builtin.keymaps, { desc = "keymaps" })
      map('n', '<leader>f?', builtin.help_tags, { desc = "help" })
      map('n', '<leader>e', builtin.find_files, { desc = "files" })
      map('n', '<leader>b', builtin.buffers, { desc = "buffers" })
      map('n', '<leader>r', builtin.oldfiles, { desc = "recent files" })
      map('n', '<leader>g', builtin.grep_string, { desc = "grep" })

    end,
  },
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
          natural_order = true,
          case_insensitive = false,
        },
      })
    end,
  },
}
