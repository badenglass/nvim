return {
  {
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
            -- find_command = { "fd", "-H", "-tf", "--strip-cwd-prefix" },
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
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      -- { "-", "<cmd>lua require('oil').open_float()<cr>", desc = "Open parent directory" },
    },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "icon",
          "size",
        },
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        -- Window-local options to use for oil buffers
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
          ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
          -- ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
          -- This function defines what will never be shown, even when `show_hidden` is set
          is_always_hidden = function(name, bufnr)
            return false
          end,
        },
      })
    end,
  },
  {
    "ThePrimeagen/harpoon",
    opts = {},
    keys = {
      { "<leader>h", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Harpoon Mark" },
      { "<leader>H", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon Menu" },
      { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", desc = "Harpoon Mark" },
      { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", desc = "Harpoon Mark" },
    },
  },
}
