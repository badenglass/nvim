local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

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

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = function()
    vim.cmd("normal! ggVGgq")
  end,
})

vim.api.nvim_create_user_command("NewClassNote", function()
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

vim.api.nvim_create_user_command("NewNote", function()
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

vim.api.nvim_create_user_command("NewDailyNote", function()
  local notes_dir = "~/Documents/notes/"
  local date_str = os.date("%d-%m-%Y")

  local filepath = notes_dir .. date_str .. ".md"

  vim.cmd("edit " .. filepath)
end, {})

vim.api.nvim_create_user_command("FindNote", function()
  local notes = require("baden.notes")
  notes.find_notes()
end, {})
