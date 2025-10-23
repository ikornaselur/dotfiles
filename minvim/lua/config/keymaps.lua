local M = {}

local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	vim.keymap.set(mode, lhs, rhs, opts)
end

function M.setup()
	-- Leader-based keymaps will expand as features are added.
	map("n", "<leader>fs", function()
		vim.cmd.write()
	end, { desc = "Save file" })

	map("n", "<Space><Space>", function()
		require("telescope.builtin").find_files({ hidden = true })
	end, { desc = "Find files" })

	local function diagnostic_jump(forward)
		return function()
			vim.diagnostic.jump({ count = (forward and 1 or -1) * vim.v.count1, float = true })
		end
	end

	map("n", "<C-h>", diagnostic_jump(false), { desc = "Prev diagnostic" })
	map("n", "<C-l>", diagnostic_jump(true), { desc = "Next diagnostic" })
end

return M
