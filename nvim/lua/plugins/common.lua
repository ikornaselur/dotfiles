local g = vim.g
local cmd = vim.cmd
local set_keymap = require('../utils').set_keymap

cmd('let mapleader = ","')
cmd('let maplocalleader = ","')

-- Theme
g.gruvbox_material_palette = 'material'
g.gruvbox_material_diagnostic_text_highlight = 1
cmd('syntax enable')
cmd('colorscheme gruvbox-material')
cmd('hi NormalFloat ctermfg=223 ctermbg=234 guifg=#d4be98 guibg=#1d2021')
cmd('hi FloatBorder ctermfg=223 ctermbg=234 guifg=#d4be98 guibg=#1d2021')
--cmd('hi DiffText guibg=#10102e')
--cmd('hi DiffAdd guibg=#102e1a')
--cmd('hi DiffChange guibg=#102e1a')

require('auto-dark-mode').setup({
  update_interval = 3000,
  set_dark_mode = function()
    vim.cmd('set background=dark')
  end,
  set_light_mode = function()
    vim.cmd('set background=light')
  end,
})
-- Airline
g.airline_theme = 'gruvbox_material'
g.airline_powerline_fonts =  1
g.airline_section_y = ''

-- IndentLine
g.indent_blankline_use_treesitter = true
g.indent_blankline_show_current_context = true
g.indent_blankline_buftype_exclude = {'terminal'}

-- VimVisualMulti
g.VM_default_mappings = 0
cmd("let g:VM_maps = {}")
cmd("let g:VM_maps[\"Add Cursor Down\"] = '<C-J>'")
cmd("let g:VM_maps[\"Add Cursor Up\"]   = '<C-K>'")

-- NERDTree
set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>')

-- Trouble
set_keymap('n', '<leader>xx', ':TroubleToggle workspace_diagnostics<CR>')

require("todo-comments").setup({})
require('git-conflict').setup({
  disable_diagnostics = true
})

-- Bad habits
require("hardtime").setup()

-- Barbecue - VSCode like winbar
require("barbecue").setup()

-----------------------
-- Language specific --
-----------------------

-- Rust
g.rustfmt_autosave = 1

-- Bash
vim.api.nvim_exec([[
autocmd Filetype sh setlocal ts=4 sw=4 sts=4 expandtab
]], false)

--[[
require("transparent").setup({
  extra_groups = {"cursorline"},
})
--]]
