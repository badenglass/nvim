local set = vim.opt_local
local map = vim.keymap.set
local usercmd = vim.api.nvim_create_user_command

set.formatoptions:remove "o"
set.shiftwidth = 4

usercmd("Build", function()
  local file = vim.fn.expand("%:p")
  local output = "/tmp/a.out"

  vim.cmd("cexpr system('g++ " .. file .. " -o " .. output .. " 2>&1')")
  if vim.v.shell_error == 0 then
    vim.notify("success", vim.log.levels.INFO)
  else
    vim.cmd("copen")
  end
end, {})

usercmd("Run", function()
  -- Get the directory of the current file
  local dir = vim.fn.expand("%:p:h")
  local output = "/tmp/a.out"

  -- Clear any existing items in the quickfix list
  vim.cmd("cexpr []")

  -- Compile all .cpp files in the current directory
  vim.cmd("cexpr system('g++ " .. dir .. "/*.cpp -o " .. output .. " 2>&1')")

  -- Check for compilation errors
  if vim.v.shell_error ~= 0 then
    -- Open quickfix list if there are errors
    vim.cmd("copen")
  else
    -- Run the compiled output and capture the result
    local result = vim.fn.system(output .. " 2>&1")
    vim.fn.setqflist({}, 'a', { title = 'Program Output', lines = vim.split(result, "\n") })

    -- Calculate dimensions and position of the floating window
    local width = math.floor(vim.o.columns * 0.4)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = vim.o.columns - width - 2

    -- Create and open a floating window to display the output
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded"
    })

    -- Run the output in a terminal and start insert mode for interaction
    vim.fn.termopen(output)
    vim.cmd("startinsert")
  end
end, {})

usercmd("RunSplit", function()
  local file = vim.fn.expand("%:p")
  local output = "/tmp/a.out"

  vim.cmd("cexpr []")
  vim.cmd("cexpr system('g++ " .. file .. " -o " .. output .. " 2>&1')")

  if vim.v.shell_error ~= 0 then
    vim.cmd("copen")
  else
    vim.cmd("vsplit | terminal " .. output)
  end
end, {})

