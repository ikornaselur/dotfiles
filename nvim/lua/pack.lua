require('paq')({
  'savq/paq-nvim';

  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' };
  'nvim-treesitter/nvim-treesitter-context';

  'nvim-lua/plenary.nvim';
  'nvim-lua/popup.nvim';

  'nvim-telescope/telescope.nvim';
  'ahmedkhalf/project.nvim';

  -- LSP tools
  {
    'williamboman/mason.nvim',
    build = function() 
      pcall(vim.cmd, 'MasonInstall') 
    end,
  }; -- LSP related package manager
  'williamboman/mason-lspconfig.nvim';  -- mason extension for lspconfig
  'neovim/nvim-lspconfig';
  'nvimtools/none-ls.nvim'; -- Linting and formatting
  'jay-babu/mason-null-ls.nvim';
  'stevearc/conform.nvim';

  -- Language specific
  'Vimjas/vim-python-pep8-indent';

  -- Visual
  'sainnhe/gruvbox-material';
  'vim-airline/vim-airline';
  'vim-airline/vim-airline-themes';
  'rcarriga/nvim-notify';
  'ryanoasis/vim-devicons';
  'nvim-tree/nvim-web-devicons';
  'lukas-reineke/indent-blankline.nvim';
  'lewis6991/gitsigns.nvim';
  'folke/lsp-colors.nvim';
  'folke/trouble.nvim';  -- Show lsp errors across the project
  'f-person/auto-dark-mode.nvim';

  -- Testing
  'vim-test/vim-test';
  'antoinemadec/FixCursorHold.nvim';
  'nvim-neotest/nvim-nio';
  'nvim-neotest/neotest';
  'nvim-neotest/neotest-python';
  'rouge8/neotest-rust';

  -- Barbecue
  'SmiteshP/nvim-navic';
  'utilyre/barbecue.nvim';

  -- Completion
  'hrsh7th/nvim-cmp';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-path';
  'hrsh7th/cmp-cmdline';
  'hrsh7th/cmp-calc';
  'hrsh7th/cmp-emoji';
  'hrsh7th/cmp-vsnip';
  'hrsh7th/vim-vsnip';

  'onsails/lspkind-nvim';

  -- Folding
  'kevinhwang91/promise-async';
  'kevinhwang91/nvim-ufo';

  -- Other
  'yioneko/nvim-yati';
  'christoomey/vim-system-copy';
  'farmergreg/vim-lastplace';
  'mg979/vim-visual-multi';
  'akinsho/nvim-toggleterm.lua';
  'preservim/nerdtree';
  'akinsho/bufferline.nvim';
  {
    'j-hui/fidget.nvim',
    branch = 'legacy',
  };
  'phaazon/hop.nvim';
  'lewis6991/impatient.nvim';
  'rmagatti/goto-preview';
  'folke/todo-comments.nvim';
  'akinsho/git-conflict.nvim';
  'zbirenbaum/copilot.lua';
  'zbirenbaum/copilot-cmp';
  'dstein64/vim-startuptime';
  'hiphish/rainbow-delimiters.nvim';
})
