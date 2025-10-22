local settings = require("config.settings")

local function filter_valid(entries)
	local list = {}
	for _, name in ipairs(entries or {}) do
		if name and name ~= "" and name ~= false then
			table.insert(list, name)
		end
	end
	return list
end

return {
	{
		"williamboman/mason.nvim",
		build = function()
			pcall(function()
				vim.cmd("MasonUpdate")
			end)
		end,
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = filter_valid(settings.mason.lsp),
		},
	},
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		opts = {
			ensure_installed = filter_valid(settings.mason.tools),
			automatic_installation = false,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = filter_valid(settings.mason.tools),
			auto_update = false,
			run_on_start = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			require("lsp").setup()
		end,
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		opts = {
			appearance = {
				use_nvim_cmp_as_default = true,
			},
			keymap = {
				preset = "default",
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			},
			sources = {
				default = { "lsp", "path", "buffer", "snippets" },
			},
			completion = {
				menu = {
					border = "rounded",
				},
			},
		},
		config = function(_, opts)
			local blink = require("blink.cmp")
			blink.setup(opts)
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		opts = {
			history = true,
			updateevents = "TextChanged,TextChangedI",
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = { notify_on_error = true },
		config = function(_, opts)
			local conform = require("conform")
			local fmt_settings = settings.formatting
			conform.setup(vim.tbl_deep_extend("force", opts, {
				notify_on_error = true,
				formatters_by_ft = require("config.formatting").build_formatter_map(),
			}))

			-- On-save formatting respecting disable list.
			if fmt_settings.format_on_save then
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("minvim-conform-format", { clear = true }),
					callback = function(args)
						local ft = vim.bo[args.buf].filetype
						if vim.tbl_contains(fmt_settings.disable_filetypes, ft) then
							return
						end
						conform.format({ bufnr = args.buf, timeout_ms = fmt_settings.timeout_ms })
					end,
				})
			end
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("lsp.null-ls").setup()
		end,
	},
}
