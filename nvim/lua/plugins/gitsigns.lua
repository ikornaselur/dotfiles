require('gitsigns').setup({
  keymaps = {
    noremap = true,
    buffer = true,
    ['n gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n gb'] = '<cmd>lua require"gitsigns".toggle_current_line_blame()<CR>',
  },
  current_line_blame_opts = {
    delay = 0,
  },
  diff_opts = {
    internal = true,
  },
})
