return {
  "ThePrimeagen/harpoon",
  opts = {},
  keys = {
    { "<leader>h", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Harpoon Mark" },
    { "<leader>H", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon Menu" },
    { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", desc = "Harpoon Mark" },
    { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", desc = "Harpoon Mark" },
  },
}
