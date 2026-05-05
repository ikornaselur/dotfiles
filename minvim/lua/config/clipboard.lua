local M = {}

function M.setup()
  if vim.env.SSH_TTY then
    local osc52 = require("vim.ui.clipboard.osc52")
    vim.g.clipboard = {
      name = "OSC 52",
      copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
      paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
    }
  end

  -- Try to ensure the system clipboard integration is available.
  -- If `unnamedplus` is unsupported, fall back to `unnamed` so yank/paste still work.
  if vim.fn.has("unnamedplus") == 1 then
    vim.opt.clipboard:prepend({ "unnamedplus" })
  else
    vim.opt.clipboard:prepend({ "unnamed" })
  end
end

return M
