require('telescope').load_extension('session-lens')
require('auto-session').setup {
  log_level = 'error'
}
require('session-lens').setup {
  shorten_path = false,
}

local set_keymap = require('../utils').set_keymap

set_keymap('n', '<c-p>', '<cmd>Telescope git_files<cr>')
set_keymap('n', '<c-g>', '<cmd>Telescope live_grep<cr>')
set_keymap('n', '<c-s>', '<cmd>Telescope session-lens search_session<cr>')
