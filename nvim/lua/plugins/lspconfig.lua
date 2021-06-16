require('lspconfig').pyright.setup({})
require('lspconfig').bashls.setup({})
require('lspconfig').cssls.setup({})
require('lspconfig').html.setup({})
require('lspconfig').jsonls.setup({})
require('lspconfig').rust_analyzer.setup({})
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
