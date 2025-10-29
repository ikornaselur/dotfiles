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

	map("n", "<leader>ff", function()
		require("telescope.builtin").find_files({ hidden = true })
	end, { desc = "Find files" })
	map("n", "<leader>fb", function()
		require("telescope.builtin").buffers()
	end, { desc = "Buffers" })
	map("n", "<leader>fh", function()
		require("telescope.builtin").help_tags()
	end, { desc = "Help tags" })
	map("n", "<leader>fr", function()
		require("telescope.builtin").oldfiles()
	end, { desc = "Recent files" })
	map("n", "<leader>/", function()
		require("telescope.builtin").live_grep()
	end, { desc = "Live grep" })

	map("n", "<leader>gs", function()
		require("telescope.builtin").git_status()
	end, { desc = "Git status" })
	map("n", "<leader>gb", function()
		require("telescope.builtin").git_branches()
	end, { desc = "Git branches" })
	map("n", "<leader>gc", function()
		require("telescope.builtin").git_commits()
	end, { desc = "Git commits" })
	map("n", "<leader>gC", function()
		require("telescope.builtin").git_bcommits()
	end, { desc = "Buffer commits" })

	map("n", "H", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
	map("n", "L", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })

	map("n", "<leader>e", function()
		require("snacks.explorer").open()
	end, { desc = "Explorer" })

	local function diagnostic_jump(forward)
		return function()
			vim.diagnostic.jump({ count = (forward and 1 or -1) * vim.v.count1, float = true })
		end
	end

	map("n", "<C-h>", diagnostic_jump(false), { desc = "Prev diagnostic" })
	map("n", "<C-l>", diagnostic_jump(true), { desc = "Next diagnostic" })

	-- Toggle dark/light background (persists on Linux via state file)
	map("n", "<leader>ub", function()
		require("config.theme").toggle()
	end, { desc = "Toggle background (dark/light)" })

	-- Optional command for scripts/mappings
	vim.api.nvim_create_user_command("MinvimToggleBackground", function()
		require("config.theme").toggle()
	end, { desc = "Toggle background between dark/light" })
end

return M
