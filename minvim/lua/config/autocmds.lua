local M = {}

function M.setup()
	local augroup = vim.api.nvim_create_augroup
	local autocmd = vim.api.nvim_create_autocmd

	-- Highlight yanked text for a brief moment.
	autocmd("TextYankPost", {
		group = augroup("minvim-highlight-yank", { clear = true }),
		callback = function()
			vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
		end,
	})

	autocmd("VimEnter", {
		group = augroup("minvim-dashboard", { clear = true }),
		callback = function()
			require("config.dashboard").show()
		end,
	})

	autocmd("BufReadPost", {
		group = augroup("minvim-last-location", { clear = true }),
		callback = function(args)
			local buf = args.buf
			local mark = vim.api.nvim_buf_get_mark(buf, '"')
			local lnum = mark[1]
			do
				local total = vim.api.nvim_buf_line_count(buf)
				if lnum <= 0 or lnum > total then
					return
				end
			end
			if vim.bo[buf].filetype == "commit" or vim.bo[buf].buftype ~= "" then
				return
			end
			vim.api.nvim_win_set_cursor(0, { lnum, math.max(mark[2], 0) })
		end,
	})
end

return M
