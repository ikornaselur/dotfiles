return {
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },
  { "folke/flash.nvim", enabled = false },
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
    config = function(_, opts)
      require("hop").setup(opts)
      vim.keymap.set("n", "f", "<cmd>HopWord<CR>", { desc = "Hop to word" })
    end,
  },
}
