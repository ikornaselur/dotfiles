local M = {}

-- Treesitter parsers to install by default. Adjust to match languages you touch often.
M.treesitter = {
	ensure_installed = {
		"lua",
		"vim",
		"vimdoc",
		"query",
		"rust",
		"python",
		"javascript",
		"typescript",
		"tsx",
		"json",
		"toml",
		"bash",
		"markdown",
		"markdown_inline",
		"yaml",
	},
}

-- Formatting behaviour.
M.formatting = {
	format_on_save = true,
	timeout_ms = 3000,
	disable_filetypes = {},
}

-- Mason install lists remain in plain tables so they can be tweaked easily.
M.mason = {
	lsp = {
		"rust_analyzer",
		"pyright",
		"ruff",
		"ts_ls",
		"eslint",
		"lua_ls",
	},
	tools = {
		"prettierd",
		"eslint_d",
		"stylua",
		"ruff",
		"ty",
	},
}

-- Language-specific preferences feed into the wider configuration.
M.languages = {
	rust = {
		lsp = {
			servers = {
				{
					name = "rust_analyzer",
					setup = "rustacean",
					settings = {},
				},
			},
		},
		formatters = {},
		extras = {
			crates = true,
			inlay_hints = true,
			rustacean = true,
		},
		null_ls = {},
	},

	python = {
		lsp = {
			servers = {
				{
					name = "pyright",
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
							},
						},
					},
				},
				{
					name = "ruff",
				},
				{
					name = "ty",
				},
			},
		},
		-- Ruff handles both linting and formatting duties. Run fix then format.
		formatters = { "ruff_fix", "ruff_format" },
		extras = {},
		null_ls = {},
	},

	javascript = {
		lsp = {
			servers = {
				{ name = "ts_ls" },
				{ name = "eslint" },
			},
		},
		formatters = { "prettierd" },
		extras = {},
		null_ls = {},
	},

	typescript = {
		lsp = {
			servers = {
				{ name = "ts_ls" },
				{ name = "eslint" },
			},
		},
		formatters = { "prettierd" },
		extras = {},
		null_ls = {},
	},

	lua = {
		lsp = {
			servers = {
				{ name = "lua_ls" },
			},
		},
		formatters = { "stylua" },
		extras = {},
		null_ls = {},
	},

	markdown = {
		lsp = {
			servers = {},
		},
		formatters = {},
		extras = {
			render_markdown = true,
		},
		null_ls = {},
	},
}

return M
