local settings = require("config.settings")

local function rustacean_enabled()
	local extras = settings.languages.rust and settings.languages.rust.extras
	return extras and extras.rustacean
end

return {
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
		cond = rustacean_enabled,
		init = function()
			local extras = settings.languages.rust.extras
			local rust_servers = settings.languages.rust.lsp.servers or {}
			local rust_settings = rust_servers[1] and rust_servers[1].settings or {}
			vim.g.rustaceanvim = {
				tools = {
					hover_actions = {
						auto_focus = false,
					},
				},
				server = {
					on_attach = require("lsp").on_attach,
					capabilities = require("lsp").capabilities(),
					default_settings = {
						["rust-analyzer"] = rust_settings,
					},
				},
			}
			vim.g.rustaceanvim.tools.inlay_hints = { auto = extras.inlay_hints ~= false }
		end,
	},
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		cond = function()
			local extras = settings.languages.rust and settings.languages.rust.extras
			return extras and extras.crates
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			completion = {
				blink = { enabled = true },
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		cond = function()
			local extras = settings.languages.markdown and settings.languages.markdown.extras
			return extras and extras.render_markdown
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
	},
}
