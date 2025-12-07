local settings = require("config.settings")

local function rustacean_enabled()
  local extras = settings.languages.rust and settings.languages.rust.extras
  return extras and extras.rustacean
end

local function rust_dap_enabled()
  local extras = settings.languages.rust and settings.languages.rust.extras
  return extras and extras.rustacean and extras.dap ~= false
end

local function mason_package_root(name)
  local base = vim.fn.expand("$MASON")
  if base == "$MASON" or base == "" then
    base = vim.fn.stdpath("data") .. "/mason"
  end
  return ("%s/packages/%s"):format(base, name)
end

local function patch_mason_get_install_path()
  local ok, mason_registry = pcall(require, "mason-registry")
  if not ok or mason_registry._minvim_get_install_path_patched then
    return
  end
  mason_registry._minvim_get_install_path_patched = true
  local orig_get_package = mason_registry.get_package
  mason_registry.get_package = function(name)
    local pkg = orig_get_package(name)
    if pkg and pkg.get_install_path == nil then
      function pkg:get_install_path()
        return mason_package_root(pkg.name or name)
      end
    end
    return pkg
  end
end

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    cond = rustacean_enabled,
    init = function()
      patch_mason_get_install_path()

      local extras = settings.languages.rust.extras
      local rust_servers = settings.languages.rust.lsp.servers or {}
      local rust_settings = rust_servers[1] and rust_servers[1].settings or {}

      local function mason_rust_analyzer_cmd()
        if extras.use_mason_rust_analyzer == false then
          return nil
        end

        local ok, mason_registry = pcall(require, "mason-registry")
        if not ok then
          return nil
        end

        local ok_pkg, ra = pcall(mason_registry.get_package, "rust-analyzer")
        if not ok_pkg or not (ra and ra.is_installed and ra:is_installed()) then
          return nil
        end

        local ok_receipt, receipt = pcall(function()
          return ra:get_receipt():get()
        end)
        local bin_name = ok_receipt
          and receipt.links
          and receipt.links.bin
          and receipt.links.bin["rust-analyzer"]

        local install_path = ra.get_install_path and ra:get_install_path()
        if not install_path then
          return nil
        end

        return { ("%s/%s"):format(install_path, bin_name or "rust-analyzer") }
      end

      local function rustacean_dap_adapter()
        if extras.dap == false then
          return nil
        end

        local ok, mason_registry = pcall(require, "mason-registry")
        if not ok then
          return nil
        end

        local ok_pkg, codelldb = pcall(mason_registry.get_package, "codelldb")
        if not ok_pkg or not (codelldb and codelldb.is_installed and codelldb:is_installed()) then
          return nil
        end

        local install_path = codelldb.get_install_path and codelldb:get_install_path()
        if not install_path then
          return nil
        end

        local extension_path = install_path .. "/extension/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
        if not vim.loop.fs_stat(liblldb_path) then
          liblldb_path = extension_path .. "lldb/lib/liblldb.so"
        end

        local cfg = require("rustaceanvim.config")
        if cfg and cfg.get_codelldb_adapter then
          return cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
        end
      end

      local server = {
        on_attach = require("lsp").on_attach,
        capabilities = require("lsp").capabilities(),
        default_settings = {
          ["rust-analyzer"] = rust_settings,
        },
      }

      local cmd = mason_rust_analyzer_cmd()
      if cmd then
        server.cmd = cmd
      end

      local dap_adapter = rustacean_dap_adapter()

      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = false,
          },
        },
        server = server,
      }
      if dap_adapter then
        vim.g.rustaceanvim.dap = { adapter = dap_adapter }
      end
      vim.g.rustaceanvim.tools.inlay_hints = { auto = extras.inlay_hints ~= false }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    cond = rust_dap_enabled,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    cond = function()
      local extras = settings.languages.rust and settings.languages.rust.extras
      return extras and extras.crates
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      completion = {
        blink = { enabled = true },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    cond = function()
      local extras = settings.languages.markdown and settings.languages.markdown.extras
      return extras and extras.render_markdown
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },
}
