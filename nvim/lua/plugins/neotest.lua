local set_keymap = require('../utils').set_keymap

require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-rust"),
  },
  icons = {
    failed = "✖",
    passed = "✓",
    running = "◷",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    skipped = "ﰸ",
    unknown = ""
  },
  quickfix = {
    enabled = false,
  },
})

set_keymap('n', '<c-t>', '<cmd>lua require("neotest").run.run()<CR>')
set_keymap('n', '<c-u>', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>')
