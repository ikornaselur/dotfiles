require("toggleterm").setup{
  size = 16,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  direction = 'horizontal',  -- 'float'
  float_opts = {
    border = 'single',
    width = 150,
    height = 40,
    winblend = 3,
  }
}

local set_keymap = require('../utils').set_keymap

set_keymap('t', '<esc>', '<C-\\><C-n>')
