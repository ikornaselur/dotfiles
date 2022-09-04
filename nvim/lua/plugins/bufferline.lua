require('bufferline').setup({
  options = {
    mode = "tabs",
    numbers = "ordinal",
    indicator = {
      icon = '▎',
      style = 'icon'
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',

    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    separator_style = "slant",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
  }
})

local set_keymap = require('../utils').set_keymap

-- These commands will navigate through buffers in order regardless of which
-- mode you are using e.g. if you change the order of buffers :bnext and
-- :bprevious will not respect the custom ordering
set_keymap('n', ']b', ':BufferLineCycleNext<CR>')
set_keymap('n', '[b', ':BufferLineCyclePrev<CR>')

-- These commands will move the current buffer backwards or forwards in the bufferline
set_keymap('n', ']B', ':BufferLineMoveNext<CR>')
set_keymap('n', '[B', ':BufferLineMovePrev<CR>')
