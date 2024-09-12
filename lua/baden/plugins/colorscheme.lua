return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none"
          },
        },
      },
    },
  },
  init = function()
    vim.cmd.colorscheme("kanagawa-dragon")
  end,
}
