vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader><esc>", "<cmd>nohl<CR>", { desc = "Clear search highlights" })

map("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Lazy" })
map("n", "<leader>a", "<cmd>Alpha<CR>", { desc = "Alpha" })

map("n", "<leader>v", "ggVG", { desc = "Highlight all" })

map("n", "<leader>n", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<leader>p", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })
map("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Delete Buffer" })

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

map("v", "<", "<gv")
map("v", ">", ">gv")
