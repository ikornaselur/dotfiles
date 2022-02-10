require('gitsigns').setup({
  keymaps = {
    noremap = true,
    buffer = true,
    ['n gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n gb'] = '<cmd>lua require"gitsigns".toggle_current_line_blame()<CR>',
    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},
  },
  word_diff = true,
  numhl = true,
  current_line_blame_opts = {
    delay = 0,
  },
  diff_opts = {
    internal = true,
  },
})

local cmd = vim.cmd

cmd("au VimEnter * highlight link GitSignsAddLnInline DiffAdd")
cmd("au VimEnter * highlight link GitSignsChangeLnInline DiffChange")
cmd("au VimEnter * highlight link GitSignsDeleteLnInline DiffDelete")
