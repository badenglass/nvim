return {
  'nvim-telescope/telescope.nvim', tag = '0.1.6',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()

    local builtin = require('telescope.builtin')
    local actions = require("telescope.actions")

    require('telescope').setup{
      defaults = {
        -- config_key = value,
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
          find_command = { "fd", "-H", "-tf", "--strip-cwd-prefix" },
          path_display = { "smart" },
        },
      },
      extensions = {},
    }

    local M = {}
    function M.find_notes()
      require("telescope.builtin").find_files {
        prompt_title = " Find Notes",
        path_display = { "smart" },
        cwd = "~/repos/vault/",
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.65, width = 0.75 },
      }
    end

    function M.find_config()
      require("telescope.builtin").find_files {
        prompt_title = " Find Notes",
        path_display = { "smart" },
        cwd = "~/.config/",
      }
    end

    function M.find_nvim()
      require("telescope.builtin").find_files {
        prompt_title = " Find Notes",
        path_display = { "smart" },
        cwd = "~/.config/nvim/",
      }
    end

    vim.keymap.set('n', '<leader>e', builtin.find_files, { desc = "find files" })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "buffers" })
    vim.keymap.set('n', '<leader>r', builtin.oldfiles, { desc = "recent files" })
    -- vim.keymap.set('n', '<leader>g', builtin.grep_string, { desc = "grep" })

    vim.keymap.set('n', '<leader>fv', M.find_notes, { desc = "find notes" })
    vim.keymap.set('n', '<leader>fc', M.find_config, { desc = "find configs" })
    vim.keymap.set('n', '<leader>fC', M.find_nvim, { desc = "find neovim config" })
    -- vim.keymap.set('n', '<leader>ff', builtin.planets, { desc = "find code" })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "keymaps" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "help" })

  end,
}
