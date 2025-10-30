local M = {}

function M.setup()
	-- Try to ensure the system clipboard integration is available.
	-- If `unnamedplus` is unsupported, fall back to `unnamed` so yank/paste still work.
	if vim.fn.has("unnamedplus") == 1 then
		vim.opt.clipboard:prepend({ "unnamedplus" })
	else
		vim.opt.clipboard:prepend({ "unnamed" })
	end
end

return M
