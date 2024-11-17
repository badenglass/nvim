require("baden.core.options")
require("baden.core.keymaps")
require("baden.core.commands")

local is_ssh = vim.env.SSH_CONNECTION ~= nil

if is_ssh then
  require("baden.remote")
end
