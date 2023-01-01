require("mason").setup()
require("mason-lspconfig").setup()
null_ls = require("null-ls")
require("mason-null-ls").setup({
  automatic_setup = true,
})
require("mason-null-ls").setup_handlers()
require('goto-preview').setup({
  height = 30,
})
null_ls.setup()

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

set_keymap('n', '<c-b>', '<cmd>lua vim.lsp.buf.format { async = true }<CR>')
set_keymap('x', '<c-b>', ":'<,'>lua vim.lsp.buf.range_formatting()<CR>")

set_keymap('n', 'gD', '<cmd>lua require("goto-preview").goto_preview_definition()<CR>')


local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
