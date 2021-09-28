local g = vim.g
local cmd = vim.cmd

-- Theme
g.gruvbox_material_palette = 'material'
g.gruvbox_material_background = 'hard'
g.gruvbox_material_diagnostic_text_highlight = 1
cmd 'syntax enable'
cmd 'colorscheme gruvbox-material'

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
cmd "let g:VM_maps = {}"
cmd "let g:VM_maps[\"Add Cursor Down\"] = '<C-J>'"
cmd "let g:VM_maps[\"Add Cursor Up\"]   = '<C-K>'"

-----------------------
-- Language specific --
-----------------------

-- Python
--cmd("autocmd BufWritePre *.py execute ':Black'")
--cmd("autocmd BufWritePre *.py execute ':PyrightOrganizeImports'")
local set_keymap = require('../utils').set_keymap
set_keymap('n', '<c-b>', '<cmd>Black<cr>')
set_keymap('x', '<c-b>', ":'<,'>BlackMacchiato<cr>")

-- Rust
g.rustfmt_autosave = 1
