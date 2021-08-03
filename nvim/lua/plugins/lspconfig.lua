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

local user = vim.fn.expand('$USER')
local sumneko_root_path = '/Users/' .. user .. '/Repos/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/macOS/lua-language-server'

require('lspconfig').sumneko_lua.setup({
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
})

local set_keymap = require('../utils').set_keymap
set_keymap('n', '<c-h>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
set_keymap('n', '<c-l>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
