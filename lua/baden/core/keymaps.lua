vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader><esc>", "<cmd>nohl<CR>", { desc = "clear search hl" })

map("n", "<leader>v", "ggVG", { desc = "highlight all" })
map("n", "<leader>V", "ggVG\"+y", { desc = "yank all" })

map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "<leader>n", "<cmd>bnext<CR>", { desc = "next buffer" })
map("n", "<leader>p", "<cmd>bprevious<CR>", { desc = "previous buffer" })
map("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "delete buffer" })

map("n", "<leader>`", "<cmd>Alpha<CR>", { desc = "dashboard" })
map('n', '<leader>fj', "<cmd>FindCode<CR>", { desc = "code" })
map('n', '<leader>fk', "<cmd>FindNote<CR>", { desc = "note" })
map('n', '<leader>fl', "<cmd>FindConfig<CR>", { desc = "config" })
map('n', '<leader>fL', "<cmd>FindNeovimConfig<CR>", { desc = "neovim config" })
