local M = {}

local settings = require("config.settings")

local function get_capabilities()
  local ok, blink = pcall(require, "blink.cmp")
  if ok and blink.get_lsp_capabilities then
    return blink.get_lsp_capabilities()
  end
  return vim.lsp.protocol.make_client_capabilities()
end

local function buf_map(bufnr, mode, lhs, rhs, desc)
  local opts = { buffer = bufnr, desc = desc }
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function register_buffer_keymaps(client, bufnr)
  buf_map(bufnr, "n", "gd", vim.lsp.buf.definition, "Goto definition")
  buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  buf_map(bufnr, "n", "gi", vim.lsp.buf.implementation, "Goto implementation")
  buf_map(bufnr, "n", "gr", vim.lsp.buf.references, "List references")

  buf_map(bufnr, "n", "K", vim.lsp.buf.hover, "Hover documentation")

  buf_map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  buf_map(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  buf_map(bufnr, "n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, "Format buffer")
  buf_map(bufnr, "n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
  buf_map(bufnr, "n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  buf_map(bufnr, "n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
end

local function try_register_with_which_key(bufnr)
  local ok, wk = pcall(require, "which-key")
  if not ok or not wk.add then
    return
  end

  wk.add({
    { "<leader>l", buffer = bufnr, group = "LSP" },
    { "<leader>la", buffer = bufnr, desc = "Code action" },
    { "<leader>ld", buffer = bufnr, desc = "Line diagnostics" },
    { "<leader>lf", buffer = bufnr, desc = "Format buffer" },
    { "<leader>lr", buffer = bufnr, desc = "Rename symbol" },
  })
end

local function apply_inlay_hints(client, bufnr)
  if not client.server_capabilities.inlayHintProvider then
    return
  end
  local ft = vim.bo[bufnr].filetype
  local lang_cfg = settings.languages[ft]
  if lang_cfg and lang_cfg.extras and lang_cfg.extras.inlay_hints then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

local function on_attach(client, bufnr)
  register_buffer_keymaps(client, bufnr)
  try_register_with_which_key(bufnr)
  apply_inlay_hints(client, bufnr)
  local ok, navic = pcall(require, "nvim-navic")
  if ok and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

M.on_attach = on_attach

function M.capabilities()
  return get_capabilities()
end

local function setup_diagnostics()
  local severity = vim.diagnostic.severity
  vim.diagnostic.config({
    float = { border = "rounded" },
    severity_sort = true,
    virtual_text = {
      severity = { min = severity.WARN },
    },
    underline = true,
    update_in_insert = false,
    signs = {
      text = {
        [severity.ERROR] = "",
        [severity.WARN] = "",
        [severity.HINT] = "",
        [severity.INFO] = "",
      },
    },
  })
end

local function setup_servers()
  local capabilities = get_capabilities()
  local has_vim_lsp_config = vim.lsp and vim.lsp.config and vim.lsp.enable

  local configured = {}

  local util = require("lspconfig.util")
  local configs = has_vim_lsp_config and nil or require("lspconfig.configs")
  local lspconfig = has_vim_lsp_config and nil or require("lspconfig")

  local function ensure_custom_server(name)
    if name ~= "ty" then
      return
    end

    local base = {
      cmd = { "ty", "server" },
      filetypes = { "python" },
      root_dir = util.root_pattern(
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
        "setup.cfg",
        ".git"
      ),
    }

    if has_vim_lsp_config then
      if not vim.lsp.config.ty then
        vim.lsp.config("ty", base)
      end
    else
      if not configs.ty then
        configs.ty = {
          default_config = base,
          docs = {
            description = [[Ty language server (ty server)]],
          },
        }
      end
    end
  end

  local function setup_server(server)
    local name = server.name
    if not name or configured[name] then
      return
    end
    configured[name] = true

    if server.setup == "rustacean" then
      return
    end

    ensure_custom_server(name)

    local server_opts = {
      capabilities = capabilities,
      on_attach = server.on_attach or M.on_attach,
    }
    if server.settings then
      server_opts.settings = server.settings
    end
    server_opts = vim.tbl_deep_extend("force", server_opts, server.opts or {})

    if name == "lua_ls" then
      server_opts.settings = vim.tbl_deep_extend("force", {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      }, server_opts.settings or {})
    end

    if has_vim_lsp_config then
      vim.lsp.config(name, server_opts)
      vim.lsp.enable(name)
    else
      lspconfig[name].setup(server_opts)
    end
  end

  for _, cfg in pairs(settings.languages) do
    local servers = cfg.lsp and cfg.lsp.servers or {}
    for _, server in ipairs(servers) do
      setup_server(server)
    end
  end
end

function M.setup()
  setup_diagnostics()
  setup_servers()
end

return M
