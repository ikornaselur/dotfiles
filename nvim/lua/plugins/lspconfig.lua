require('lspconfig').pyright.setup({})
require('lspconfig').bashls.setup({})
require('lspconfig').cssls.setup({})
require('lspconfig').html.setup({})
require('lspconfig').jsonls.setup({})
require('lspconfig').rust_analyzer.setup({
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = "clippy"
      }
    }
  }
})
require('lspconfig').sqlls.setup({
  cmd = { '/usr/local/bin/sql-language-server', 'up', '--method', 'stdio' },
})
require('lspconfig').tsserver.setup({})
require('lspconfig').vimls.setup({})
require('lspconfig').yamlls.setup({})

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

local set_keymap = require('../common').set_keymap
set_keymap('n', '<c-h>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
set_keymap('n', '<c-l>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
