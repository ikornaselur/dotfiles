local lsp_installer = require("nvim-lsp-installer")

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<c-h>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<c-l>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'L', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)


  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

lsp_installer.on_server_ready(function(server)
  local config = {
    on_attach = on_attach
  }
  if server.name == "rust_analyzer" then
    config.settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        }
      }
    }
  end
  if server.name == "efm" then
    config.flags = {debounce_text_changes = 1000}
    config.init_options = {documentFormatting = true}
    config.settings = {
      rootMarkers = {".git/", "pyproject.toml"},
      lintDebounce = "1s",
      formatDebounce = "1000ms",
      languages = {
        python = {
          {
            lintCommand = "flake8 --stdin-display-name ${INPUT} -",
            lintStdin = true,
            lintFormats = {"%f:%l:%c: %m"}
          }
        }
      }
    }
  end

  server:setup(config)
end)
