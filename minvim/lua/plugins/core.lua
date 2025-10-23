return {
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_better_performance = 1
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local auto_dark_mode = require("auto-dark-mode")
			auto_dark_mode.setup({
				update_interval = 1000,
				set_dark_mode = function()
					vim.opt.background = "dark"
					vim.cmd.colorscheme("gruvbox-material")
				end,
				set_light_mode = function()
					vim.opt.background = "light"
					vim.cmd.colorscheme("gruvbox-material")
				end,
			})
			auto_dark_mode.init()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local ts_settings = require("config.settings").treesitter
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = ts_settings.ensure_installed,
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				},
			}
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			pcall(telescope.load_extension, "fzf")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{
		"smoka7/hop.nvim",
		version = false,
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
		config = function(_, opts)
			local hop = require("hop")
			hop.setup(opts)
			vim.keymap.set("n", "f", function()
				hop.hint_words()
			end, { desc = "Hop to word" })
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<C-/>]],
			shade_terminals = false,
		},
	},
}
