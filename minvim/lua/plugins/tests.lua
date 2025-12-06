return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-plenary",
    },
    keys = {
      {
        "<leader>tf",
        function()
          require("config.testing").run_file()
        end,
        desc = "File tests",
      },
      {
        "<leader>ts",
        function()
          require("config.testing").toggle_summary()
        end,
        desc = "Toggle summary",
      },
      {
        "<leader>tn",
        function()
          require("config.testing").run_nearest()
        end,
        desc = "Nearest test",
      },
      {
        "<leader>ta",
        function()
          require("config.testing").run_project()
        end,
        desc = "All tests (project)",
      },
    },
    opts = function()
      local adapters = {}
      local rust_adapter_added = false

      local ok_rustacean, rustacean = pcall(require, "rustaceanvim.neotest")
      if ok_rustacean then
        table.insert(adapters, rustacean)
        rust_adapter_added = true
      end

      local ok_python, python = pcall(require, "neotest-python")
      if ok_python then
        table.insert(adapters, python({ runner = "pytest" }))
      end

      local ok_vitest, vitest = pcall(require, "neotest-vitest")
      if ok_vitest then
        table.insert(adapters, vitest({}))
      end

      local ok_jest, jest = pcall(require, "neotest-jest")
      if ok_jest then
        table.insert(adapters, jest({}))
      end

      local ok_rust, rust = pcall(require, "neotest-rust")
      if ok_rust and not rust_adapter_added then
        table.insert(
          adapters,
          rust({
            args = { "--", "--nocapture" },
            cargo_toml = function(path)
              -- Anchor to the nearest Cargo.toml so workspaces with nested crates resolve correctly.
              return vim.fs.find("Cargo.toml", { path = path, upward = true })[1]
            end,
          })
        )
      end

      local ok_plenary, plenary = pcall(require, "neotest-plenary")
      if ok_plenary then
        table.insert(adapters, plenary())
      end

      return {
        adapters = adapters,
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },
}
