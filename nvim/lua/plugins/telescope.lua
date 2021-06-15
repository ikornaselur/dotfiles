require('telescope').load_extension('session-lens')
require('telescope').load_extension('heading')

local set_keymap = require('../common').set_keymap

set_keymap('n', '<c-p>', '<cmd>Telescope git_files<cr>')
set_keymap('n', '<c-g>', '<cmd>Telescope live_grep<cr>')
