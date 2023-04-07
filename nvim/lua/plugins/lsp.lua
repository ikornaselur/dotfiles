require("mason").setup()
require("mason-lspconfig").setup()
require("mason-null-ls").setup({
  automatic_installation = false,
  automatic_setup = true,
})
require("null-ls").setup()
require("mason-null-ls").setup_handlers()
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

set_keymap('n', '<space>b', '<cmd>lua vim.lsp.buf.format { async = true }<CR>')

set_keymap('n', 'gD', '<cmd>lua require("goto-preview").goto_preview_definition()<CR>')

-- Use internal formatting for bindings like gq. 
vim.api.nvim_create_autocmd('LspAttach', { 
  callback = function(args) 
    vim.bo[args.buf].formatexpr = nil 
  end, 
})

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

require('lspconfig')['pyright'].setup({
  on_attach = on_attach,
  flags = lsp_flags,
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


vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
