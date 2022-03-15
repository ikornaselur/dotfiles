local g = vim.g
local cmd = vim.cmd
local set_keymap = require('../utils').set_keymap

cmd('let mapleader = ","')

-- Theme
g.gruvbox_material_palette = 'material'
g.gruvbox_material_background = 'hard'
g.gruvbox_material_diagnostic_text_highlight = 1
cmd('syntax enable')
cmd('colorscheme gruvbox-material')

-- Airline
g.airline_theme = 'gruvbox_material'
g.airline_powerline_fonts =  1
g.airline_section_y = ''
cmd("let g:airline#extensions#tabline#enabled = 1")
cmd("let g:airline#extensions#tabline#show_close_button = 0")
cmd("let g:airline#extensions#tabline#tabs_label = ''")
cmd("let g:airline#extensions#tabline#buffers_label = ''")
cmd("let g:airline#extensions#tabline#fnamemod = ':t'")
cmd("let g:airline#extensions#tabline#show_tab_count = 0")
cmd("let g:airline#extensions#tabline#show_buffers = 0")
cmd("let g:airline#extensions#tabline#tab_min_count = 2")
cmd("let g:airline#extensions#tabline#show_tab_nr = 0")

-- IndentLine
g.indent_blankline_use_treesitter = true
g.indent_blankline_show_current_context = true
g.indent_blankline_buftype_exclude = {'terminal'}

-- VimVisualMulti
g.VM_default_mappings = 0
cmd("let g:VM_maps = {}")
cmd("let g:VM_maps[\"Add Cursor Down\"] = '<C-J>'")
cmd("let g:VM_maps[\"Add Cursor Up\"]   = '<C-K>'")

-- Ultest
set_keymap('n', '<c-t>', ':UltestNearest<cr>')
set_keymap('n', '<c-u>', ':Ultest<cr>')
set_keymap('n', 'U', ':UltestSummary<cr>')
set_keymap('n', '<c-y>', ':UltestOutput<cr>')
cmd("let g:ultest_use_pty = 1")

-- NERDTree
set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>')


-----------------------
-- Language specific --
-----------------------

-- Python
cmd("autocmd BufWritePost *.py call flake8#Flake8()")
cmd("let g:flake8_show_in_gutter=1")
cmd("let g:flake8_show_quickfix=0")
set_keymap('n', '<c-b>', '<cmd>Black<cr>')
set_keymap('x', '<c-b>', ":'<,'>BlackMacchiato<cr>")

-- Rust
g.rustfmt_autosave = 1

-- Bash
vim.api.nvim_exec([[
autocmd Filetype sh setlocal ts=4 sw=4 sts=4 expandtab
]], false)
