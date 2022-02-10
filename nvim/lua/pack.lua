local cmd = vim.cmd

require('paq')({
  'savq/paq-nvim';

  {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};
  'nvim-treesitter/playground';

  'nvim-lua/plenary.nvim';
  'nvim-lua/popup.nvim';

  'nvim-telescope/telescope.nvim';
  'ahmedkhalf/project.nvim';

  'rcarriga/nvim-notify';
  'christoomey/vim-system-copy';
  'farmergreg/vim-lastplace';
  'hrsh7th/nvim-compe';
  'hrsh7th/vim-vsnip';
  'mg979/vim-visual-multi';
  'neovim/nvim-lspconfig';
  'williamboman/nvim-lsp-installer';
  'sainnhe/gruvbox-material';
  'vim-airline/vim-airline';
  'kyazdani42/nvim-web-devicons';
  'lewis6991/gitsigns.nvim';
  'lukas-reineke/indent-blankline.nvim';
  'onsails/lspkind-nvim';
  'akinsho/nvim-toggleterm.lua';
  'rust-lang/rust.vim';
  'psf/black';
  'smbl64/vim-black-macchiato';
  'Vimjas/vim-python-pep8-indent';
  'nvie/vim-flake8';
})
