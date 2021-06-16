local cmd = vim.cmd

cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq

paq({'savq/paq-nvim', opt = true})
paq({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
paq('nvim-treesitter/playground')

paq('nvim-lua/plenary.nvim')
paq('nvim-lua/popup.nvim')

paq('nvim-telescope/telescope.nvim')
paq('rmagatti/auto-session')
paq('rmagatti/session-lens')
paq('crispgm/telescope-heading.nvim')

paq('christoomey/vim-system-copy')
paq('farmergreg/vim-lastplace')
paq('hrsh7th/nvim-compe')
paq('hrsh7th/vim-vsnip')
paq('mg979/vim-visual-multi')
paq('neovim/nvim-lspconfig')
paq('sainnhe/gruvbox-material')
paq('vim-airline/vim-airline')
paq('lewis6991/gitsigns.nvim')
paq({
  'lukas-reineke/indent-blankline.nvim',
  branch = 'lua',
})
paq('onsails/lspkind-nvim')
