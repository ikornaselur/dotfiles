local M = setmetatable({}, {
	__call = function(m, ...)
		return m.get(...)
	end,
})

-- Default root detection order (matches LazyVim):
-- 1) LSP workspace/root_dir, 2) patterns like .git, 3) fallback to cwd
M.spec = { "lsp", { ".git", "lua" }, "cwd" }

M.detectors = {}

function M.detectors.cwd()
	return { vim.uv.cwd() }
end

function M.detectors.lsp(buf)
	local bufpath = M.bufpath(buf)
	if not bufpath then
		return {}
	end

	local roots = {}
	local clients = vim.lsp.get_clients({ bufnr = buf })
	local ignore = vim.g.root_lsp_ignore or { "copilot" }
	for _, client in ipairs(clients) do
		if not vim.tbl_contains(ignore, client.name) then
			if client.config and client.config.workspace_folders then
				for _, ws in ipairs(client.config.workspace_folders) do
					local p = vim.uri_to_fname(ws.uri)
					if p then
						roots[#roots + 1] = p
					end
				end
			end
			if client.root_dir then
				roots[#roots + 1] = client.root_dir
			end
		end
	end

	local ret = {}
	for _, path in ipairs(roots) do
		local norm = M.realpath(path)
		if norm and bufpath:find(norm, 1, true) == 1 then
			table.insert(ret, norm)
		end
	end
	return ret
end

function M.detectors.pattern(buf, patterns)
	patterns = type(patterns) == "string" and { patterns } or patterns
	local start = M.bufpath(buf) or vim.uv.cwd()
	local match = vim.fs.find(function(name)
		for _, p in ipairs(patterns) do
			if name == p then
				return true
			end
			if p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$") then
				return true
			end
		end
		return false
	end, { path = start, upward = true })[1]
	return match and { vim.fs.dirname(match) } or {}
end

function M.bufpath(buf)
	local name = vim.api.nvim_buf_get_name(buf or 0)
	return M.realpath(name)
end

function M.cwd()
	return M.realpath(vim.uv.cwd()) or ""
end

function M.realpath(path)
	if not path or path == "" then
		return nil
	end
	local rp = vim.uv.fs_realpath(path) or path
	return vim.fs.normalize(rp)
end

local function resolve(spec)
	if M.detectors[spec] then
		return M.detectors[spec]
	elseif type(spec) == "function" then
		return spec
	end
	return function(buf)
		return M.detectors.pattern(buf, spec)
	end
end

-- opts: { buf?: number, spec?: LazyRootSpec[], all?: boolean, normalize?: boolean }
function M.detect(opts)
	opts = opts or {}
	local spec = opts.spec or (type(vim.g.root_spec) == "table" and vim.g.root_spec) or M.spec
	local buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

	local ret = {}
	for _, s in ipairs(spec) do
		local paths = resolve(s)(buf) or {}
		if type(paths) ~= "table" then
			paths = { paths }
		end
		local unique = {}
		for _, p in ipairs(paths) do
			local rp = M.realpath(p)
			if rp and not vim.tbl_contains(unique, rp) then
				table.insert(unique, rp)
			end
		end
		table.sort(unique, function(a, b)
			return #a > #b
		end)
		if #unique > 0 then
			table.insert(ret, { spec = s, paths = unique })
			if opts.all == false then
				break
			end
		end
	end
	return ret
end

M.cache = {}

function M.setup()
	vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "DirChanged", "BufEnter" }, {
		group = vim.api.nvim_create_augroup("minvim_root_cache", { clear = true }),
		callback = function(event)
			M.cache[event.buf] = nil
		end,
	})
end

function M.get(opts)
	opts = opts or {}
	local buf = opts.buf or vim.api.nvim_get_current_buf()
	local cached = M.cache[buf]
	if not cached then
		local roots = M.detect({ all = false, buf = buf })
		cached = roots[1] and roots[1].paths[1] or vim.uv.cwd()
		M.cache[buf] = cached
	end
	return opts.normalize and cached or cached
end

function M.git()
	local root = M.get()
	local git_dir = vim.fs.find(".git", { path = root, upward = true })[1]
	return git_dir and vim.fn.fnamemodify(git_dir, ":h") or root
end

return M
