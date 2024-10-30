local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '100' })
  end
})

autocmd('BufWritePre', {
  pattern = '',
  command = ":%s/\\s\\+$//e"
})

autocmd("BufWritePre", {
  pattern = "*.cpp,*.h",
  callback = function()
    vim.cmd("LspZeroFormat")
  end,
})

autocmd("BufWritePre", {
  pattern = "*.md",
  callback = function()
    vim.cmd("echo 'fix me!'")
  end,
})

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

usercmd("FindConfig", function()
  require("telescope.builtin").find_files {
    prompt_title = " Find Config",
    path_display = { "smart" },
    cwd = "~/.config/",
  }
end, {})

usercmd("FindNeovimConfig", function()
  require("telescope.builtin").find_files {
    prompt_title = " Find Neovim Config",
    path_display = { "smart" },
    cwd = "~/.config/nvim/",
  }
end, {})
