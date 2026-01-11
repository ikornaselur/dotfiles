local M = {}

local banner = {
  " ███▄ ▄███▓ ██▓ ███▄    █ ██▒   █▓ ██▓ ███▄ ▄███▓",
  "▓██▒▀█▀ ██▒▓██▒ ██ ▀█   █▓██░   █▒▓██▒▓██▒▀█▀ ██▒",
  "▓██    ▓██░▒██▒▓██  ▀█ ██▒▓██  █▒░▒██▒▓██    ▓██░",
  "▒██    ▒██ ░██░▓██▒  ▐▌██▒ ▒██ █░░░██░▒██    ▒██ ",
  "▒██▒   ░██▒░██░▒██░   ▓██░  ▒▀█░  ░██░▒██▒   ░██▒",
  "░ ▒░   ░  ░░▓  ░ ▒░   ▒ ▒   ░ ▐░  ░▓  ░ ▒░   ░  ░",
  "░  ░      ░ ▒ ░░ ░░   ░ ▒░  ░ ░░   ▒ ░░  ░      ░",
  "░      ░    ▒ ░   ░   ░ ░     ░░   ▒ ░░      ░   ",
  "       ░    ░           ░      ░   ░         ░   ",
  "                              ░                ",
}

local function telescope_action(method, opts)
  return function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if not ok then
      vim.notify("telescope.nvim is not available", vim.log.levels.ERROR)
      return
    end
    builtin[method](opts or {})
  end
end

local buttons = {
  { key = "f", icon = "", label = "Find file", action = telescope_action("find_files") },
  {
    key = "n",
    icon = "",
    label = "New file",
    action = function()
      vim.cmd.enew()
    end,
  },
  { key = "g", icon = "", label = "Find text", action = telescope_action("live_grep") },
  {
    key = "r",
    icon = "",
    label = "Recent files",
    action = telescope_action("oldfiles", { cwd_only = true }),
  },
  {
    key = "c",
    icon = "",
    label = "Config",
    action = function()
      local path = vim.fn.stdpath("config") .. "/init.lua"
      vim.cmd("edit " .. vim.fn.fnameescape(path))
    end,
  },
  {
    key = "s",
    icon = "",
    label = "Restore session",
    action = function()
      vim.notify("Session restore not configured yet", vim.log.levels.INFO)
    end,
  },
  {
    key = "l",
    icon = "󰒲",
    label = "Lazy",
    action = function()
      vim.cmd.Lazy()
    end,
  },
  {
    key = "q",
    icon = "",
    label = "Quit",
    action = function()
      vim.cmd.qa()
    end,
  },
}

local state = {
  buf = nil,
  win = nil,
  laststatus = nil,
  last_ruler = nil,
  augroup = nil,
  button_meta = nil,
  selection = 1,
}

local ns = vim.api.nvim_create_namespace("minvim-dashboard")
local sel_ns = vim.api.nvim_create_namespace("minvim-dashboard-selection")
local banner_width = 0
for _, line in ipairs(banner) do
  banner_width = math.max(banner_width, vim.fn.strdisplaywidth(line))
end

local function teardown()
  if state.laststatus ~= nil then
    vim.o.laststatus = state.laststatus
  end
  if state.last_ruler ~= nil then
    vim.o.ruler = state.last_ruler
  end
  if state.augroup then
    pcall(vim.api.nvim_del_augroup_by_id, state.augroup)
    state.augroup = nil
  end
  state.buf = nil
  state.win = nil
  state.laststatus = nil
  state.last_ruler = nil
  state.button_meta = nil
  state.selection = 1
end

local function center_line(text, width)
  local pad = math.max(0, math.floor((width - vim.fn.strdisplaywidth(text)) / 2))
  return string.rep(" ", pad) .. text
end

local function compute_button_layout(width)
  local layout = {}
  local max_label = 0
  local max_key = 0

  for _, button in ipairs(buttons) do
    local icon = button.icon or " "
    local label = string.format("%s  %s", icon, button.label)
    local key = button.key
    local label_width = vim.fn.strdisplaywidth(label)
    local key_width = vim.fn.strdisplaywidth(key)
    max_label = math.max(max_label, label_width)
    max_key = math.max(max_key, key_width)
    table.insert(layout, {
      label = label,
      key = key,
      label_width = label_width,
      key_width = key_width,
      icon = icon,
      button = button,
    })
  end

  local min_gap = 6
  local desired_width = math.max(banner_width, max_label + min_gap + max_key)
  local indent = math.max(0, math.floor((width - desired_width) / 2))

  for _, item in ipairs(layout) do
    local gap = math.max(min_gap, desired_width - (item.label_width + item.key_width))
    local line = string.rep(" ", indent) .. item.label .. string.rep(" ", gap) .. item.key

    local display_width = vim.fn.strdisplaywidth(line)
    if display_width < width then
      line = line .. string.rep(" ", width - display_width)
    end

    item.line = line
    item.label_start = indent
    item.label_end = indent + item.label_width
    item.key_start = indent + item.label_width + gap
    item.key_end = item.key_start + item.key_width

    local icon = item.icon or ""
    local text_pos = line:find(item.button.label, 1, true)
    if text_pos then
      item.text_col = text_pos - 1
    else
      local icon_bytes = #icon
      item.text_col = indent + icon_bytes + 2
    end
  end

  return layout
end

local function redraw_selection()
  local meta = state.button_meta
  local sel = state.selection or 1
  if not meta or not meta[sel] then
    return
  end

  local item = meta[sel]
  local line_idx = (item.line_idx or 1) - 1

  local win = state.win
  if win and vim.api.nvim_win_is_valid(win) then
    local col = item.text_col or item.label_start
    vim.api.nvim_win_set_cursor(win, { line_idx + 1, col })
  end
end

local function set_selection(idx)
  if #buttons == 0 then
    state.selection = 1
    return
  end
  local count = #buttons
  local normalized = ((idx - 1) % count) + 1
  state.selection = normalized
  redraw_selection()
end

local function move_selection(delta)
  set_selection((state.selection or 1) + delta)
end

local function render()
  local buf, win = state.buf, state.win
  if not buf or not win then
    return
  end
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
    return
  end

  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)

  local total_lines = #banner + #buttons * 2 + 2
  local base_pad = math.max(0, math.floor((height - total_lines) / 2))
  local top_pad = math.max(0, math.floor(base_pad * 0.6))

  local lines = {}
  for _ = 1, top_pad do
    table.insert(lines, "")
  end
  table.insert(lines, "")
  for _, line in ipairs(banner) do
    table.insert(lines, center_line(line, width))
  end
  table.insert(lines, "")
  table.insert(lines, "")

  local button_meta = compute_button_layout(width)
  for idx, item in ipairs(button_meta) do
    table.insert(lines, item.line)
    item.line_idx = #lines
    if idx ~= #button_meta then
      table.insert(lines, "")
    end
  end

  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for idx = 0, #banner - 1 do
    local line_idx = top_pad + 1 + idx
    vim.api.nvim_buf_add_highlight(buf, ns, "Title", line_idx, 0, -1)
  end

  for _, meta in ipairs(button_meta) do
    local line_idx = meta.line_idx - 1
    vim.api.nvim_buf_add_highlight(buf, ns, "Title", line_idx, meta.label_start, meta.key_end)
  end

  state.button_meta = button_meta
  set_selection(state.selection or 1)
end

local function close_dashboard(action)
  local buf = state.buf
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  else
    teardown()
  end

  if action then
    vim.schedule(action)
  end
end

local function execute_selection()
  local sel = state.selection or 1
  local button = buttons[sel]
  if button then
    close_dashboard(button.action)
  end
end

local function setup_keymaps(buf)
  for idx, button in ipairs(buttons) do
    vim.keymap.set("n", button.key, function()
      set_selection(idx)
      close_dashboard(button.action)
    end, { buffer = buf, nowait = true, silent = true })
  end

  vim.keymap.set("n", "<Esc>", function()
    close_dashboard()
  end, { buffer = buf, nowait = true, silent = true })

  local function map(lhs, fn)
    vim.keymap.set("n", lhs, fn, { buffer = buf, nowait = true, silent = true })
  end

  map("<Down>", function()
    move_selection(1)
  end)
  map("j", function()
    move_selection(1)
  end)
  map("<Up>", function()
    move_selection(-1)
  end)
  map("k", function()
    move_selection(-1)
  end)
  map("<Tab>", function()
    move_selection(1)
  end)
  map("<S-Tab>", function()
    move_selection(-1)
  end)
  map("<CR>", execute_selection)
  map("<Space>", execute_selection)

  map("i", function()
    close_dashboard(function()
      vim.cmd.enew()
      vim.cmd.startinsert()
    end)
  end)
end

function M.show()
  if vim.fn.argc() > 0 or vim.api.nvim_buf_get_name(0) ~= "" or vim.bo.buftype ~= "" then
    return
  end

  vim.cmd.enew()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  state.buf = buf
  state.win = win
  state.laststatus = vim.o.laststatus
  state.last_ruler = vim.o.ruler
  vim.o.laststatus = 0
  vim.o.ruler = false
  state.selection = 1

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false
  vim.bo[buf].filetype = "minvim-dashboard"

  vim.opt_local.modifiable = false
  vim.opt_local.cursorline = false
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.list = false
  vim.opt_local.wrap = false
  vim.opt_local.spell = false
  vim.opt_local.colorcolumn = ""
  vim.opt_local.statuscolumn = ""
  vim.opt_local.winbar = ""

  local fillchars = vim.opt_local.fillchars:get()
  fillchars.eob = " "
  vim.opt_local.fillchars = fillchars

  setup_keymaps(buf)
  render()

  state.augroup = vim.api.nvim_create_augroup("minvim-dashboard", { clear = true })

  vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    group = state.augroup,
    callback = function()
      if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        render()
      end
    end,
  })

  for _, event in ipairs({ "BufLeave", "BufReadPre", "BufWipeout" }) do
    vim.api.nvim_create_autocmd(event, {
      buffer = buf,
      once = true,
      callback = teardown,
    })
  end

  vim.b.minvim_dashboard = true
end

return M
