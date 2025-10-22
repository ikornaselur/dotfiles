local M = {}

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.setup()
  -- Leader-based keymaps will expand as features are added.
  map("n", "<leader>fs", function()
    vim.cmd.write()
  end, { desc = "Save file" })

  -- Quick escape using jk to leave insert mode; adjust if undesired.
  map("i", "jk", "<ESC>")
end

return M
