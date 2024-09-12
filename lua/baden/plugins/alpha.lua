return {
     "goolord/alpha-nvim",
     config = function ()
         local alpha = require'alpha'
         local dashboard = require'alpha.themes.dashboard'
         dashboard.section.header.val = {
             [[                               __                ]],
             [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
             [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
             [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
             [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
             [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
         }
         dashboard.section.buttons.val = {
             dashboard.button( "e", "  New file" , ":ene <BAR> startinsert <CR>"),
             dashboard.button( "r", "􀈎  Recent files" , ":Telescope oldfiles<CR>"),
             dashboard.button( "l", "􀇳  Code" , ":cd ~/repos/ciss245 <BAR> edit ~/repos/ciss245/main.cpp<CR>"),
             dashboard.button( "n", "􀦌  Open Notes" , ":terminal open $(fd . -tf '/Users/baden/Documents/cccs/notes' | fzf) <CR>"),
             dashboard.button( "a", "􁚛  Open Assignments" , ":terminal open $(fd . -tf '/Users/baden/Documents/cccs/assignments' | fzf) <CR>"),
             dashboard.button( "q", "󰅚  Quit NVIM" , ":qa<CR>"),

         }
         local handle = io.popen('fortune')
         local fortune = handle:read("*a")
         handle:close()
         dashboard.section.footer.val = fortune

         dashboard.config.opts.noautocmd = true

         vim.cmd[[autocmd User AlphaReady echo 'nice']]

         alpha.setup(dashboard.config)
     end
 }
