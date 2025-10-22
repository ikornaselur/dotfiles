-- Leader keys must be set before Lazy is required
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Bootstrap Lazy.nvim if it is not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load core config pieces (defined under lua/config)
require("config.options").setup()
require("config.keymaps").setup()
require("config.autocmds").setup()

-- Initialize Lazy with plugin modules housed under lua/plugins/
require("lazy").setup({ import = "plugins" }, {
	defaults = { lazy = false, version = false },
	install = { colorscheme = { "gruvbox-material" } },
	checker = { enabled = false },
	change_detection = { notify = false },
})
