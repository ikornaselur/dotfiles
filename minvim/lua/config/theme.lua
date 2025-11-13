local M = {}

local uv = vim.uv or vim.loop
local is_macos = (uv.os_uname().sysname == "Darwin")

local state_file = vim.fn.stdpath("state") .. "/minvim_theme.txt"

local function read_file(path)
  if vim.fn.filereadable(path) == 1 then
    local lines = vim.fn.readfile(path)
    if lines and #lines > 0 then
      return lines[1]
    end
  end
end

local function write_file(path, contents)
  pcall(vim.fn.writefile, { contents }, path)
end

local function apply(mode)
  if mode ~= "dark" and mode ~= "light" then
    return
  end
  vim.opt.background = mode
  -- Re-apply the colorscheme to refresh highlights across all windows/buffers
  pcall(vim.cmd.colorscheme, "gruvbox-material")
end

function M.current()
  return (vim.o.background == "light") and "light" or "dark"
end

function M.toggle()
  local next_mode = (M.current() == "dark") and "light" or "dark"
  apply(next_mode)
  -- Persist only when auto-dark-mode is not active (i.e. non-macOS)
  if not is_macos then
    write_file(state_file, next_mode)
  end
end

function M.setup()
  -- On non-macOS, load persisted preference early so the initial colorscheme matches.
  if not is_macos then
    local saved = read_file(state_file)
    if saved == "dark" or saved == "light" then
      apply(saved)
    end
  end
end

return M
