local cmd = vim.cmd

cmd 'packadd paq-nvim'
require('paq-nvim')({
  {'savq/paq-nvim', opt = true};

  {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};
  'nvim-treesitter/playground';

  'nvim-lua/plenary.nvim';
  'nvim-lua/popup.nvim';

  'nvim-telescope/telescope.nvim';
  'rmagatti/auto-session';
  'rmagatti/session-lens';

  'christoomey/vim-system-copy';
  'farmergreg/vim-lastplace';
  'hrsh7th/nvim-compe';
  'hrsh7th/vim-vsnip';
  'mg979/vim-visual-multi';
  'neovim/nvim-lspconfig';
  'sainnhe/gruvbox-material';
  'vim-airline/vim-airline';
  'kyazdani42/nvim-web-devicons';
  'lewis6991/gitsigns.nvim';
  {
    'lukas-reineke/indent-blankline.nvim',
    branch = 'lua',
  };
  'onsails/lspkind-nvim';
  'akinsho/nvim-toggleterm.lua';
  'petobens/poet-v';
  'airblade/vim-rooter';
  'rust-lang/rust.vim';
})
