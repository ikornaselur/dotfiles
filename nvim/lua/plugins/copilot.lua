require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = {
    python = true,
    rust = true,
    lua = true,
    javascript = true,
    typescript = true,
    ["*"] = false,
  },
})
require("copilot_cmp").setup()
