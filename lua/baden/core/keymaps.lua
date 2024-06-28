vim.g.mapleader = " "

local map = vim.keymap.set -- for conciseness

map("n", "<leader><esc>", "<cmd>nohl<CR>", { desc = "Clear search highlights" })

map("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Lazy" })
map("n", "<leader>a", "<cmd>Alpha<CR>", { desc = "Alpha" })

map("n", "<leader>va", "ggVG", { desc = "Highlight all" })

map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height

map("n", "<leader>n", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<leader>p", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })
map("n", "<leader>z", "<cmd>only<CR>", { desc = "Focus Buffer" })
map("n", "<leader>w", "<cmd>close<CR>", { desc = "Close Buffer" })
map("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Delete Buffer" })

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" }) -- split window vertically
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" }) -- split window vertically

map("v", "<", "<gv")
map("v", ">", ">gv")

