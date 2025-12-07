local M = {}

local function mason_base()
  local base = vim.fn.expand("$MASON")
  if base == "$MASON" or base == "" then
    base = vim.fn.stdpath("data") .. "/mason"
  end
  return base
end

local function find_codelldb_paths()
  local base = mason_base()
  local package_root = ("%s/packages/codelldb/extension"):format(base)
  local adapter = package_root .. "/adapter/codelldb"
  local lib = package_root .. "/lldb/lib/liblldb.dylib"

  if vim.loop.fs_stat(adapter .. ".exe") then
    adapter = adapter .. ".exe"
  end

  if not vim.loop.fs_stat(lib) then
    lib = package_root .. "/lldb/lib/liblldb.so"
  end

  if not vim.loop.fs_stat(adapter) or not vim.loop.fs_stat(lib) then
    adapter = nil
    lib = nil
  end

  if not adapter and vim.fn.executable("codelldb") == 1 then
    adapter = vim.fn.exepath("codelldb")
  end

  return adapter, lib
end

function M.codelldb_adapter()
  local adapter_path, liblldb_path = find_codelldb_paths()
  if not adapter_path then
    return nil
  end

  local ok, cfg = pcall(require, "rustaceanvim.config")
  if ok and cfg.get_codelldb_adapter and liblldb_path then
    return cfg.get_codelldb_adapter(adapter_path, liblldb_path)
  end

  return {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = adapter_path,
      args = { "--port", "${port}" },
    },
  }
end

local function setup_adapter()
  local dap = require("dap")
  if dap.adapters.codelldb then
    return
  end

  local adapter = M.codelldb_adapter()
  if not adapter then
    vim.notify("codelldb not found (install via Mason)", vim.log.levels.WARN)
    return
  end

  dap.adapters.codelldb = adapter
end

local function setup_rust()
  local dap = require("dap")
  if dap.configurations.rust then
    return
  end

  dap.configurations.rust = {
    {
      name = "Rust: debug (prompt)",
      type = "codelldb",
      request = "launch",
      program = function()
        local default = vim.fn.getcwd() .. "/target/debug/"
        return vim.fn.input("Binary to debug: ", default, "file")
      end,
      args = function()
        local input = vim.fn.input("Args: ")
        if input == "" then
          return nil
        end
        return vim.split(input, "%s+", { trimempty = true })
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      console = "integratedTerminal",
    },
  }
end

local function setup_ui()
  local ok, dapui = pcall(require, "dapui")
  if not ok then
    return
  end

  dapui.setup({ controls = { enabled = false } })

  local dap = require("dap")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

local short_active = false
local short_saved = {}

local short_keys = {
  n = function()
    require("dap").step_over()
  end,
  s = function()
    require("dap").step_into()
  end,
  o = function()
    require("dap").step_out()
  end,
  c = function()
    require("dap").continue()
  end,
  q = function()
    require("dap").terminate()
  end,
}

local function save_existing(lhs)
  local existing = vim.fn.maparg(lhs, "n", false, true)
  if existing and existing.lhs then
    short_saved[lhs] = existing
  end
end

local function restore_saved(lhs)
  local prev = short_saved[lhs]
  short_saved[lhs] = nil
  if not prev or not prev.lhs or not prev.rhs then
    pcall(vim.keymap.del, "n", lhs)
    return
  end

  local opts = {
    noremap = prev.noremap == 1,
    silent = prev.silent == 1,
    expr = prev.expr == 1,
    nowait = prev.nowait == 1,
    script = prev.script == 1,
  }
  local rhs = prev.rhs
  if prev.expr == 1 and type(rhs) == "string" then
    opts.expr = true
  end
  pcall(vim.api.nvim_set_keymap, "n", lhs, rhs, opts)
end

local function enable_shortcuts()
  if short_active then
    return
  end
  short_active = true
  local buf = vim.api.nvim_get_current_buf()
  for lhs, fn in pairs(short_keys) do
    save_existing(lhs)
    vim.keymap.set("n", lhs, fn, { desc = "DAP session: " .. lhs, silent = true, nowait = true })
  end

  local ok, wk = pcall(require, "which-key")
  if ok and wk.add then
    local entries = {
      { "n", desc = "DAP: step over", mode = "n", buffer = buf },
      { "s", desc = "DAP: step into", mode = "n", buffer = buf },
      { "o", desc = "DAP: step out", mode = "n", buffer = buf },
      { "c", desc = "DAP: continue", mode = "n", buffer = buf },
      { "q", desc = "DAP: terminate", mode = "n", buffer = buf },
    }
    wk.add(entries, { notify = false })
  end
end

local function disable_shortcuts()
  if not short_active then
    return
  end
  short_active = false
  for lhs in pairs(short_keys) do
    restore_saved(lhs)
  end

  local ok, wk = pcall(require, "which-key")
  if ok and wk.add then
    local buf = vim.api.nvim_get_current_buf()
    wk.add({}, { buffer = buf, mode = "n", notify = false })
  end
end

local function setup_keymaps()
  local dap = require("dap")
  local ok_ui, dapui = pcall(require, "dapui")

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
  end

  map("<leader>db", function()
    dap.toggle_breakpoint()
  end, "DAP: toggle breakpoint")

  map("<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, "DAP: conditional breakpoint")

  map("<leader>dc", function()
    dap.continue()
  end, "DAP: continue/start")

  map("<leader>do", function()
    dap.step_over()
  end, "DAP: step over")

  map("<leader>di", function()
    dap.step_into()
  end, "DAP: step into")

  map("<leader>du", function()
    dap.step_out()
  end, "DAP: step out")

  map("<leader>dr", function()
    dap.repl.toggle()
  end, "DAP: REPL")

  if ok_ui then
    map("<leader>dui", function()
      dapui.toggle({})
    end, "DAP: toggle UI")

    map("<leader>dE", function()
      dapui.eval(nil, { enter = true })
    end, "DAP: eval (hover/selection)")
  end

  dap.listeners.after.event_initialized["dap_shortcuts"] = enable_shortcuts
  dap.listeners.before.event_terminated["dap_shortcuts"] = disable_shortcuts
  dap.listeners.before.event_exited["dap_shortcuts"] = disable_shortcuts
end

function M.setup()
  setup_adapter()
  setup_rust()
  setup_ui()
  setup_keymaps()
end

return M
