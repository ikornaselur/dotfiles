require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', 'gp', gs.preview_hunk)
    map('n', 'gb', gs.toggle_current_line_blame)
  end,
  word_diff = false,
  linehl = true,
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
