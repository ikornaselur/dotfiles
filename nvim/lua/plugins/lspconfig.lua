local function setup_servers()
  require('lspinstall').setup()
  local servers = require('lspinstall').installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end

setup_servers()

require('lspinstall').post_install_hook = function ()
  setup_servers()
  vim.cmd("bufdo e")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local set_keymap = require('../utils').set_keymap
set_keymap('n', '<c-h>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
set_keymap('n', '<c-l>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
