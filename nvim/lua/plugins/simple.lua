local g = vim.g
local cmd = vim.cmd

-- Theme
g.gruvbox_material_palette = 'original'
g.gruvbox_material_background = 'hard'
cmd 'syntax enable'
cmd 'colorscheme gruvbox-material'

-- Airline
g.airline_theme = 'gruvbox_material'
g.airline_powerline_fonts =  1
g.airline_section_y = ''

-- IndentLine
g.indent_blankline_use_treesitter = true
g.indent_blankline_show_current_context = true

-- VimVisualMulti
g.VM_default_mappings = 0
cmd "let g:VM_maps = {}"
cmd "let g:VM_maps[\"Add Cursor Down\"] = '<C-J>'"
cmd "let g:VM_maps[\"Add Cursor Up\"]   = '<C-K>'"

-- Rooter
g.rooter_patterns = {'.git', 'Makefile', 'pyproject.toml', 'Cargo.toml', 'package.json'}

-----------------------
-- Language specific --
-----------------------

-- Python
cmd("autocmd BufWritePre *.py execute ':Black'")
cmd("autocmd BufWritePre *.py execute ':PyrightOrganizeImports'")
g.poetv_executables = {'poetry'}
g.poetv_auto_activate = 1

-- Rust
g.rustfmt_autosave = 1
