local settings = require("config.settings")

local function rust_dap_enabled()
  local extras = settings.languages.rust and settings.languages.rust.extras
  return extras and extras.rustacean and extras.dap ~= false
end

return {
  {
    "mfussenegger/nvim-dap",
    cond = rust_dap_enabled,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      require("config.dap").setup()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    cond = rust_dap_enabled,
    dependencies = { "nvim-neotest/nvim-nio" },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    cond = rust_dap_enabled,
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "codelldb" },
      automatic_installation = true,
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    cond = rust_dap_enabled,
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      commented = true,
      virt_text_pos = "eol",
      show_stop_reason = true,
      all_frames = false,
    },
  },
}
