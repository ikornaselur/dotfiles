local M = {}

local function has_parser(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  return ok and parser ~= nil
end

local function ensure_treesitter(buf)
  if has_parser(buf) then
    return true
  end
  local ok = pcall(vim.treesitter.start, buf)
  return ok and has_parser(buf)
end

local function refresh(buf)
  buf = buf or 0
  local o = vim.opt_local

  o.foldenable = true
  o.foldlevel = 99
  o.foldlevelstart = 99

  if ensure_treesitter(buf) then
    o.foldmethod = "expr"
    o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.cmd, "silent! keepjumps keepmarks zx")
      end
    end)
  else
    o.foldmethod = "indent"
    o.foldexpr = ""
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("minvim-folds", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "python", "rust" },
    callback = function(event)
      refresh(event.buf)
    end,
  })
end

M.refresh = refresh

return M
