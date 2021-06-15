local cmd = vim.cmd

cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq

paq({'savq/paq-nvim', opt = true})
paq({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
paq({'nvim-treesitter/playground'})
paq({'neovim/nvim-lspconfig'})
paq({'hrsh7th/nvim-compe'})
paq({'hrsh7th/vim-vsnip'})
paq({'nvim-lua/popup.nvim'})
paq({'nvim-lua/plenary.nvim'})
paq({'nvim-telescope/telescope.nvim'})
paq({'sainnhe/gruvbox-material'})
paq({'vim-airline/vim-airline'})
paq({'mg979/vim-visual-multi'})
paq({'Yggdroot/indentLine'})
