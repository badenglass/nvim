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

-- autocmd("BufWritePre", {
--   pattern = "*.cpp,*.h",
--   callback = function()
--     vim.cmd("LspZeroFormat")
--   end,
-- })

autocmd("BufWritePre", {
  pattern = "*.md",
  callback = function()
    vim.cmd("echo 'fix me!'")
  end,
})
