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
  opt.confirm = true
  opt.laststatus = 3
  opt.showmode = false
  opt.ruler = false
  opt.ignorecase = true
  opt.smartcase = true

  -- Folding: use Treesitter for intelligent folds.
  -- Keep folds open by default but enable folding and let users close when desired.
  opt.foldmethod = "expr"
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  opt.foldenable = true
  opt.foldlevel = 99
  opt.foldlevelstart = 99

  -- Persist view data like folds when saving/loading views.
  -- (We create autocmds to mkview/loadview in config.autocmds.)
  pcall(function()
    vim.opt.viewoptions:append("folds")
  end)

  -- Clipboard and undo directories are left at Neovim defaults for now
  -- so they can be tailored once this config is under regular use.
end

return M
