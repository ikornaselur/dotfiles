require('paq')({
  'savq/paq-nvim';

  {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};
  'nvim-treesitter/playground';

  'nvim-lua/plenary.nvim';
  'nvim-lua/popup.nvim';

  'nvim-telescope/telescope.nvim';
  'ahmedkhalf/project.nvim';

  -- LSP tools
  'williamboman/mason.nvim'; -- LSP related package manager
  'williamboman/mason-lspconfig.nvim';  -- mason extension for lspconfig
  'neovim/nvim-lspconfig';
  'jose-elias-alvarez/null-ls.nvim'; -- Linting and formatting
  'jayp0521/mason-null-ls.nvim';

  -- Language specific
  'rust-lang/rust.vim';
  'Vimjas/vim-python-pep8-indent';

  -- Visual
  'sainnhe/gruvbox-material';
  'vim-airline/vim-airline';
  'vim-airline/vim-airline-themes';
  'rcarriga/nvim-notify';
  'ryanoasis/vim-devicons';
  'kyazdani42/nvim-web-devicons';
  'lukas-reineke/indent-blankline.nvim';
  'lewis6991/gitsigns.nvim';
  'folke/lsp-colors.nvim';
  'folke/trouble.nvim';  -- Show lsp errors across the project

  -- Testing
  'vim-test/vim-test';
  'antoinemadec/FixCursorHold.nvim';
  'nvim-neotest/neotest';
  'nvim-neotest/neotest-python';
  'rouge8/neotest-rust';

  -- Other
  'christoomey/vim-system-copy';
  'farmergreg/vim-lastplace';
  'hrsh7th/nvim-compe';
  'hrsh7th/vim-vsnip';
  'mg979/vim-visual-multi';
  'onsails/lspkind-nvim';
  'akinsho/nvim-toggleterm.lua';
  'preservim/nerdtree';
  'lewis6991/nvim-treesitter-context';
  'akinsho/bufferline.nvim';
  'j-hui/fidget.nvim';
  'phaazon/hop.nvim';
  'lewis6991/impatient.nvim';
})
