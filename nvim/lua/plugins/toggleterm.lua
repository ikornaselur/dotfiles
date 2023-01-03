require("toggleterm").setup{
  size = 16,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  direction = 'float',
  float_opts = {
    border = 'curved',
    winblend = 0,
  }
}

local set_keymap = require('../utils').set_keymap

set_keymap('t', '<esc>', '<C-\\><C-n>')
