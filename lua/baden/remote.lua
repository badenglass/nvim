local usercmd = vim.api.nvim_create_user_command
local map = vim.keymap.set

map('n', '<leader>fj', "<cmd>FindCode<CR>", { desc = "code" })
map('n', '<leader>fk', "<cmd>FindNote<CR>", { desc = "note" })
map('n', '<leader>fl', "<cmd>FindConfig<CR>", { desc = "config" })
map('n', '<leader>fL', "<cmd>FindNeovimConfig<CR>", { desc = "neovim config" })

usercmd("NewClassNote", function()
  local notes_dir = "~/repos/ciss245/e/notes/"
  local filename = vim.fn.input("class note filename: ")

  if filename == "" then
    print("Invalid filename")
    return
  end

  if not filename:match("%.md$") then
    filename = filename .. ".md"
  end

  local filepath = notes_dir .. filename

  vim.cmd("edit " .. filepath)
end, {})

usercmd("NewNote", function()
  local notes_dir = "~/Documents/notes/"
  local filename = vim.fn.input("Note filename: ")

  if filename == "" then
    print("Invalid filename")
    return
  end

  if not filename:match("%.md$") then
    filename = filename .. ".md"
  end

  local date_str = os.date("%d-%m-%Y")

  local filepath = notes_dir .. filename

  vim.cmd("edit " .. filepath)
end, {})

usercmd("DailyNote", function()
  local notes_dir = "~/Documents/notes/"
  local date_str = os.date("%d-%m-%Y")

  local filepath = notes_dir .. date_str .. ".md"

  vim.cmd("edit " .. filepath)
end, {})

usercmd("FindNote", function()
  require("telescope.builtin").find_files {
    prompt_title = " Find Notes",
    path_display = { "smart" },
    cwd = "~/Documents/notes/",
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.65, width = 0.75 }
  }
end, {})

usercmd("FindCode", function()
  require("telescope.builtin").find_files {
    prompt_title = " Find Code",
    path_display = { "smart" },
    cwd = "~/repos/ciss245/",
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.65, width = 0.75 }
  }
end, {})

