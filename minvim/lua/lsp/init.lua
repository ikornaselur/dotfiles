local M = {}

local settings = require("config.settings")

local function get_capabilities()
	local ok, blink = pcall(require, "blink.cmp")
	if ok and blink.get_lsp_capabilities then
		return blink.get_lsp_capabilities()
	end
	return vim.lsp.protocol.make_client_capabilities()
end

local function buf_map(bufnr, mode, lhs, rhs, desc)
	local opts = { buffer = bufnr, desc = desc }
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function register_buffer_keymaps(bufnr)
	buf_map(bufnr, "n", "gd", vim.lsp.buf.definition, "Goto definition")
	buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration, "Goto declaration")
	buf_map(bufnr, "n", "gi", vim.lsp.buf.implementation, "Goto implementation")
	buf_map(bufnr, "n", "gr", vim.lsp.buf.references, "List references")
	buf_map(bufnr, "n", "K", vim.lsp.buf.hover, "Hover documentation")
	buf_map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	buf_map(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
	buf_map(bufnr, "n", "<leader>lf", function()
		vim.lsp.buf.format({ async = true })
	end, "Format buffer")
	buf_map(bufnr, "n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
	buf_map(bufnr, "n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
	buf_map(bufnr, "n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
end

local function try_register_with_which_key(bufnr)
	local ok, wk = pcall(require, "which-key")
	if not ok then
		return
	end

	wk.register({
		l = {
			name = "+LSP",
			f = "Format buffer",
			d = "Line diagnostics",
			r = "Rename symbol",
			a = "Code action",
		},
	}, { prefix = "<leader>", buffer = bufnr })
end

local function apply_inlay_hints(client, bufnr)
	if not client.server_capabilities.inlayHintProvider then
		return
	end
	local ft = vim.bo[bufnr].filetype
	local lang_cfg = settings.languages[ft]
	if lang_cfg and lang_cfg.extras and lang_cfg.extras.inlay_hints then
		vim.lsp.inlay_hint(bufnr, true)
	end
end

local function on_attach(client, bufnr)
	register_buffer_keymaps(bufnr)
	try_register_with_which_key(bufnr)
	apply_inlay_hints(client, bufnr)
end

M.on_attach = on_attach

function M.capabilities()
	return get_capabilities()
end

local function setup_diagnostics()
	vim.diagnostic.config({
		float = { border = "rounded" },
		severity_sort = true,
		virtual_text = {
			severity = { min = vim.diagnostic.severity.WARN },
		},
		underline = true,
		update_in_insert = false,
	})

	local signs = { Error = "", Warn = "", Hint = "", Info = "" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
end

local function setup_servers()
	local lspconfig = require("lspconfig")
	local capabilities = get_capabilities()

	local configured = {}

	local configs = require("lspconfig.configs")
	local util = require("lspconfig.util")

	local function ensure_custom_server(name)
		if name == "ty" and not configs.ty then
			configs.ty = {
				default_config = {
					cmd = { "ty", "server" },
					filetypes = { "python" },
					root_dir = util.root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", "setup.cfg", ".git"),
				},
				docs = {
					description = [[Ty language server (ty server)]],
				},
			}
		end
	end

	local function setup_server(server)
		local name = server.name
		if not name or configured[name] then
			return
		end
		configured[name] = true

		if server.setup == "rustacean" then
			return
		end

		ensure_custom_server(name)

		local server_opts = vim.tbl_deep_extend("force", {
			capabilities = capabilities,
			on_attach = server.on_attach or M.on_attach,
			settings = server.settings,
		}, server.opts or {})

		if name == "lua_ls" then
			server_opts.settings = vim.tbl_deep_extend("force", {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			}, server_opts.settings or {})
		end

		lspconfig[name].setup(server_opts)
	end

	for _, cfg in pairs(settings.languages) do
		local servers = cfg.lsp and cfg.lsp.servers or {}
		for _, server in ipairs(servers) do
			setup_server(server)
		end
	end
end

function M.setup()
	setup_diagnostics()
	setup_servers()
end

return M
