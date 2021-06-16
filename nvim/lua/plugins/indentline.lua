local g = vim.g
local cmd = vim.cmd

g.indent_blankline_use_treesitter = true
g.indent_blankline_show_current_context = true

cmd('highlight IndentBlanklineContextChar guifg=#00FF00 gui=nocombine')
