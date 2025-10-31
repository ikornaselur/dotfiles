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

  -- Git: toggle inline blame for current buffer
  map("n", "<leader>gh", function()
    require("gitsigns").toggle_current_line_blame()
  end, { desc = "Git blame (toggle line blame)" })
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

  -- Formatting on demand (Conform)
  map("n", "<leader>cf", function()
    require("config.formatting").format()
  end, { desc = "Format (Conform)" })
  map("n", "<leader>cF", function()
    require("config.formatting").autofix()
  end, { desc = "Autofix + format" })

  -- Folding helpers (Treesitter-powered foldexpr configured in options)
  -- Native z-motions still work; these are simple leader aliases.
  map("n", "<leader>zf", "za", { desc = "Fold toggle" })
  map("n", "<leader>zo", "zo", { desc = "Open fold" })
  map("n", "<leader>zO", "zO", { desc = "Open folds recursively" })
  map("n", "<leader>zc", "zc", { desc = "Close fold" })
  map("n", "<leader>zC", "zC", { desc = "Close folds recursively" })
  map("n", "<leader>zR", "zR", { desc = "Open all folds" })
  map("n", "<leader>zM", "zM", { desc = "Close all folds" })
  map("n", "<leader>zj", "zj", { desc = "Next fold" })
  map("n", "<leader>zk", "zk", { desc = "Prev fold" })

  -- UI toggle: enable/disable folding entirely
  map("n", "<leader>uz", function()
    vim.o.foldenable = not vim.o.foldenable
  end, { desc = "Toggle folds (enable)" })

  -- Optional command for scripts/mappings
  vim.api.nvim_create_user_command("MinvimToggleBackground", function()
    require("config.theme").toggle()
  end, { desc = "Toggle background between dark/light" })
  vim.api.nvim_create_user_command("MinvimFormat", function()
    require("config.formatting").format()
  end, { desc = "Format current buffer (Conform)" })
  vim.api.nvim_create_user_command("MinvimFix", function()
    require("config.formatting").autofix()
  end, { desc = "Autofix current buffer (ESLint/Ruff)" })
end

return M
