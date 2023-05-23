require('paq')({
  'savq/paq-nvim';

  {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};
  'nvim-treesitter/playground';

  'nvim-lua/plenary.nvim';
  'nvim-lua/popup.nvim';

  'nvim-telescope/telescope.nvim';
  'ahmedkhalf/project.nvim';

  -- LSP tools
  {
    'williamboman/mason.nvim',
    run = function() 
      pcall(vim.cmd, 'MasonInstall') 
    end,
  }; -- LSP related package manager
  'williamboman/mason-lspconfig.nvim';  -- mason extension for lspconfig
  'neovim/nvim-lspconfig';
  'jose-elias-alvarez/null-ls.nvim'; -- Linting and formatting
  'jayp0521/mason-null-ls.nvim';

  -- Language specific
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

  -- Completion
  'hrsh7th/nvim-cmp';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-path';
  'hrsh7th/cmp-cmdline';
  'hrsh7th/cmp-calc';
  'hrsh7th/cmp-emoji';
  'onsails/lspkind-nvim';

  -- Other
  'yioneko/nvim-yati';
  'christoomey/vim-system-copy';
  'farmergreg/vim-lastplace';
  'mg979/vim-visual-multi';
  'akinsho/nvim-toggleterm.lua';
  'preservim/nerdtree';
  'lewis6991/nvim-treesitter-context';
  'akinsho/bufferline.nvim';
  'j-hui/fidget.nvim';
  'phaazon/hop.nvim';
  'lewis6991/impatient.nvim';
  'rmagatti/goto-preview';
  --'xiyaowong/nvim-transparent';
  'folke/todo-comments.nvim';
  'akinsho/git-conflict.nvim';
  'zbirenbaum/copilot.lua';
  'zbirenbaum/copilot-cmp';
  'dstein64/vim-startuptime';
})
