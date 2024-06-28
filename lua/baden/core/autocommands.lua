local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

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

autocmd('VimEnter', {
  command = "echo 'nice'"
})
