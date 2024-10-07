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
  command = "echo 'get nasty'"
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local theme_conf = vim.fn.expand("~/.config/kitty/theme.conf")
        local file = io.open(theme_conf, "r")
        if file then
            local theme = file:read("*line")
            file:close()

            -- Define the list of valid themes
            local valid_themes = {
                "monokai-pro-classic",
                "monokai-pro-default",
                "monokai-pro-machine",
                "monokai-pro-octagon",
                "monokai-pro-ristretto",
                "monokai-pro-spectrum"
            }

            -- Check if the theme from the file is valid
            if vim.tbl_contains(valid_themes, theme) then
                vim.cmd("colorscheme " .. theme)
            else
                vim.api.nvim_echo({{"Error: Invalid theme in theme.conf"}}, true, {})
            end
        else
            vim.api.nvim_echo({{"Error: Could not read theme.conf"}}, true, {})
        end
    end,
})


-- keymap(bufnr, 'n', '<leader>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
