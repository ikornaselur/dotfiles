local M = {}

function M.setup()
  -- Editor defaults live here; populate as the config matures.
  local opt = vim.opt

  opt.termguicolors = true
  opt.number = true
  opt.relativenumber = true
  opt.expandtab = true
  opt.shiftwidth = 2
  opt.tabstop = 2
  opt.smartindent = true
  opt.wrap = false
  opt.splitright = true
  opt.splitbelow = true
  opt.cursorline = true
  opt.signcolumn = "yes"
  opt.updatetime = 250
  opt.timeoutlen = 400

  -- Clipboard and undo directories are left at Neovim defaults for now
  -- so they can be tailored once this config is under regular use.
end

return M
