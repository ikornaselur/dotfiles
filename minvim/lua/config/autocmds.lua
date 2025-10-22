local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd

  -- Highlight yanked text for a brief moment.
  autocmd("TextYankPost", {
    group = augroup("minvim-highlight-yank", { clear = true }),
    callback = function()
      vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
    end,
  })
end

return M
