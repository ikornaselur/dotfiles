require('hop').setup()

local set_keymap = require('../utils').set_keymap

set_keymap('n', 'f', ':HopWord<CR>')
