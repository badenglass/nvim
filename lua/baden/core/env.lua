local is_ssh = vim.env.SSH_CONNECTION ~= nil

local function echo_env()
  if is_ssh then
    vim.cmd("echo 'on remote machine'")
  else
    vim.cmd("echo 'local machine'")
  end
end

vim.api.nvim_create_user_command("Check", function()
  echo_env()
end, {})
