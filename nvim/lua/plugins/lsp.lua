require("mason").setup()
require("mason-lspconfig").setup()
require("mason-null-ls").setup({
  automatic_installation = false,
  handlers = {},
})
require("null-ls").setup()
require('goto-preview').setup({
  width = 200; -- Width of the floating window
  height = 30; -- Height of the floating window
})

local set_keymap = require('../utils').set_keymap

set_keymap('n', '<c-h>', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
set_keymap('n', '<c-l>', '<cmd>lua vim.diagnostic.goto_next()<CR>')
set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
set_keymap('n', 'L', '<cmd>lua vim.diagnostic.open_float()<CR>')
set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')

set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

set_keymap('n', '<space>b', '<cmd>lua require("conform").format()<CR>')

set_keymap('n', 'gD', '<cmd>lua require("goto-preview").goto_preview_definition()<CR>')

-- Use internal formatting for bindings like gq. 
vim.api.nvim_create_autocmd('LspAttach', { 
  callback = function(args) 
    vim.bo[args.buf].formatexpr = nil 
  end, 
})

local inlay_hints_enabled = true
function ToggleInlayHints()
  inlay_hints_enabled = not inlay_hints_enabled
  vim.lsp.inlay_hint.enable(inlay_hints_enabled)
  if inlay_hints_enabled then
    print("Inlay hints enabled")
  else
    print("Inlay hints disabled")
  end
end
set_keymap('n', '<leader>ih', '<cmd>lua ToggleInlayHints()<CR>')
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.lsp.inlay_hint.enable(inlay_hints_enabled)
end


for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end

require('lspconfig')['pyright'].setup({
  on_attach = on_attach,
  flags = lsp_flags,
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
})
require('lspconfig')['rust_analyzer'].setup({
  on_attach = on_attach,
  flags = lsp_flags,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy"
      }
    }
  }
})
require('lspconfig')['ruff'].setup({
  on_attach = on_attach,
  init_options = {
    settings = {
      args = {},
    }
  }
})

require("conform").setup({
  formatters_by_ft = {
    python = {
      "ruff_fix",    -- ruff check --fix
      "ruff_format", -- ruff format
    },
  },
})


vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
