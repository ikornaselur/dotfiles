local opt = vim.opt
local cmd = vim.cmd

local set_keymap = require('utils').set_keymap

cmd 'filetype plugin indent on'

opt.completeopt = {'menuone', 'noselect'}

opt.number = true
opt.relativenumber = true

opt.backspace = {'indent','eol','start'}  -- Make backspace work as expected
opt.mouse = 'nicr'                -- Enables mouse scrolling in vim inside iterm2
opt.sidescroll = 1                -- Scroll one char horizontally instead of half page
opt.sidescrolloff = 20            -- How many chars away from the edge should start scroll
opt.linebreak = true

opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

opt.hlsearch = true               -- Highlight when searching
opt.ignorecase = true             -- Ignore casing while searching
opt.incsearch = true              -- Incremental search while typing

opt.termguicolors = true
opt.background = 'dark'

opt.hidden = true
opt.cursorline = true

opt.foldmethod = 'expr'
-- opt.foldexpr = 'nvim_treesitter#foldexpr()' -- Use treesitter for folding expr
opt.foldlevelstart = 50
opt.foldenable = true

require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})

-- opt.colorcolumn = '80,120'
