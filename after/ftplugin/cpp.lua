local set = vim.opt_local

set.formatoptions:remove "o"
set.shiftwidth = 4

vim.keymap.set("n", "<leader>m", "<cmd>make<CR>", { desc = "Execute Make" })
