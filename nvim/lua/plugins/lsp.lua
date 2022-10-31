require("mason").setup()
require("mason-lspconfig").setup()
require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.isort,
    require("null-ls").builtins.formatting.black,
    require("null-ls").builtins.diagnostics.flake8,
    require("null-ls").builtins.completion.spell,
  },
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

set_keymap('n', '<c-b>', '<cmd>lua vim.lsp.buf.formatting()<CR>')
set_keymap('x', '<c-b>', ":'<,'>lua vim.lsp.buf.range_formatting()<CR>")
