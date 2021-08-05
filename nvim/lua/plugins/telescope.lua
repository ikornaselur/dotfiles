require('auto-session').setup({})
require('session-lens').setup({
  path_display={'shorten'},
})

local set_keymap = require('../utils').set_keymap

set_keymap('n', '<c-p>', '<cmd>Telescope git_files<cr>')
set_keymap('n', '<c-g>', '<cmd>Telescope live_grep<cr>')
set_keymap('n', '<c-s>', '<cmd>Telescope session-lens search_session<cr>')
