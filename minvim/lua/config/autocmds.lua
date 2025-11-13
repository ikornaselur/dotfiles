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

  autocmd("VimEnter", {
    group = augroup("minvim-dashboard", { clear = true }),
    callback = function()
      require("config.dashboard").show()
    end,
  })

  autocmd("BufReadPost", {
    group = augroup("minvim-last-location", { clear = true }),
    callback = function(args)
      local buf = args.buf
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      local lnum = mark[1]
      do
        local total = vim.api.nvim_buf_line_count(buf)
        if lnum <= 0 or lnum > total then
          return
        end
      end
      if vim.bo[buf].filetype == "commit" or vim.bo[buf].buftype ~= "" then
        return
      end
      vim.api.nvim_win_set_cursor(0, { lnum, math.max(mark[2], 0) })
    end,
  })

  autocmd("BufEnter", {
    group = augroup("minvim-statusline", { clear = true }),
    callback = function()
      if vim.bo.filetype ~= "dashboard" then
        vim.o.laststatus = 3
      end
    end,
  })

  -- Remember folds and other view-related state per file.
  -- Uses mkview/loadview which writes to stdpath('state')/view.
  local function should_persist_view(buf)
    local bt = vim.bo[buf].buftype
    if bt ~= "" then
      return false
    end
    if vim.bo[buf].modified == false and not vim.bo[buf].modifiable then
      return false
    end
    local ft = vim.bo[buf].filetype
    local skip = {
      "gitcommit",
      "gitrebase",
      "help",
      "dashboard",
      "lazy",
      "mason",
      "neo-tree",
      "snacks_explorer",
      "toggleterm",
      "Trouble",
      "trouble",
    }
    for _, s in ipairs(skip) do
      if ft == s then
        return false
      end
    end
    return true
  end

  autocmd("BufWinLeave", {
    group = augroup("minvim-remember-folds", { clear = true }),
    callback = function(args)
      if should_persist_view(args.buf) then
        pcall(vim.cmd, "silent! mkview")
      end
    end,
  })

  autocmd("BufWinEnter", {
    group = augroup("minvim-remember-folds", { clear = false }),
    callback = function(args)
      if should_persist_view(args.buf) then
        pcall(vim.cmd, "silent! loadview")
      end
    end,
  })
end

return M
