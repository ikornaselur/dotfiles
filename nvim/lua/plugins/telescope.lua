require('telescope').setup({
  defaults = {
    winblend = 0,
    layout_config = {
      preview_width = 0.5
    },
    path_display = {'truncate'},
    mappings = {
      i = {
        ['<c-d>'] = require('telescope.actions').delete_buffer
      }
    }
  }
})
require("project_nvim").setup({})
require('telescope').load_extension('projects')
--require('auto-session').setup({})
--[[
require('session-lens').setup({
  path_display={'shorten'},
})
]]--

local set_keymap = require('../utils').set_keymap

set_keymap('n', '<c-p>', '<cmd>Telescope git_files<cr>')
set_keymap('n', '<c-g>', '<cmd>Telescope live_grep<cr>')
set_keymap('n', '<c-b>', '<cmd>Telescope buffers<cr>')
set_keymap('n', '<c-s>', '<cmd>Telescope projects<cr>')
