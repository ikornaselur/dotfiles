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
    local root = require("util.root").get()
    require("telescope.builtin").find_files({ hidden = true, cwd = root })
  end, { desc = "Find files" })

  map("n", "<leader>ff", function()
    local root = require("util.root").get()
    require("telescope.builtin").find_files({ hidden = true, cwd = root })
  end, { desc = "Find files (root)" })
  map("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
  end, { desc = "Buffers" })
  map("n", "<leader>fh", function()
    require("telescope.builtin").help_tags()
  end, { desc = "Help tags" })
  map("n", "<leader>fr", function()
    local root = require("util.root").get()
    require("telescope.builtin").oldfiles({ cwd_only = false, cwd = root })
  end, { desc = "Recent files (root)" })
  map("n", "<leader>/", function()
    local root = require("util.root").get()
    require("telescope.builtin").live_grep({ cwd = root })
  end, { desc = "Live grep (root)" })

  map("n", "<leader>gs", function()
    local root = require("util.root").git()
    require("telescope.builtin").git_status({ cwd = root })
  end, { desc = "Git status (root)" })
  map("n", "<leader>gb", function()
    local root = require("util.root").git()
    require("telescope.builtin").git_branches({ cwd = root })
  end, { desc = "Git branches (root)" })
  map("n", "<leader>gc", function()
    local root = require("util.root").git()
    require("telescope.builtin").git_commits({ cwd = root })
  end, { desc = "Git commits (root)" })
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
