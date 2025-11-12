local M = {}

local function build_opts(max_lines_override)
  local ok, settings = pcall(require, "config.settings")
  local cfg = ok and settings.ui and settings.ui.treesitter_context or {}
  if type(cfg) ~= "table" then
    cfg = {}
  end

  local opts = {
    enable = true,
    max_lines = max_lines_override or cfg.max_lines or 3,
    multiline_threshold = cfg.multiline_threshold or 20,
    trim_scope = cfg.trim_scope or "outer",
    mode = cfg.mode or "cursor",
    separator = cfg.separator, -- nil disables separator line
    zindex = cfg.zindex or 20,
  }
  return opts
end

local state = {
  expanded = false,
  peek_active = false,
  peek_augroup = nil,
  peek_timer = nil,
}

local function safe_setup(opts)
  local ok, ctx = pcall(require, "treesitter-context")
  if not ok then
    vim.notify("treesitter-context not available", vim.log.levels.WARN)
    return false
  end
  ctx.setup(opts)
  return true
end

function M.expand()
  if state.expanded then
    return
  end
  if safe_setup(build_opts(0)) then
    state.expanded = true
  end
end

function M.restore()
  if not state.expanded then
    return
  end
  if safe_setup(build_opts(nil)) then
    state.expanded = false
  end
end

function M.toggle_expand()
  if state.expanded then
    M.restore()
  else
    M.expand()
  end
end

local function clear_peek_watchers(restore)
  if state.peek_augroup then
    pcall(vim.api.nvim_del_augroup_by_id, state.peek_augroup)
    state.peek_augroup = nil
  end
  if state.peek_timer then
    pcall(state.peek_timer.stop, state.peek_timer)
    pcall(state.peek_timer.close, state.peek_timer)
    state.peek_timer = nil
  end
  state.peek_active = false
  if restore then
    if not state.expanded then
      safe_setup(build_opts(nil))
    end
  end
end

function M.peek(timeout_ms)
  local ok, settings = pcall(require, "config.settings")
  local cfg = ok and settings.ui and settings.ui.treesitter_context or {}
  local ms = timeout_ms or cfg.peek_timeout_ms or 1500

  -- Apply expanded context
  if not safe_setup(build_opts(0)) then
    return
  end

  -- Clear any prior peek watchers/timer
  clear_peek_watchers(false)
  state.peek_active = true

  -- Restore on next movement/editor state change
  state.peek_augroup = vim.api.nvim_create_augroup("minvim-context-peek", { clear = true })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "BufLeave", "FocusLost" }, {
    group = state.peek_augroup,
    once = true,
    callback = function()
      clear_peek_watchers(true)
    end,
  })

  -- Or restore after a short timeout
  local uv = vim.uv or vim.loop
  local t = uv.new_timer()
  state.peek_timer = t
  t:start(ms, 0, function()
    vim.schedule(function()
      clear_peek_watchers(true)
    end)
  end)
end

-- Expose a user command friendly alias
M.peek_once = M.peek

return M
