local M = {}

local function has_parser(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  return ok and parser ~= nil
end

local function ensure_treesitter(buf)
  if not has_parser(buf) then
    local ok = pcall(vim.treesitter.start, buf)
    if not (ok and has_parser(buf)) then
      return false
    end
  end
  -- Force a full synchronous parse so fold levels exist immediately. On large
  -- files the initial parse is otherwise deferred, leaving foldexpr returning 0
  -- for every line (symptom: "E490: No fold found" on the whole buffer).
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if ok and parser then
    pcall(function()
      parser:parse(true)
    end)
  end
  return true
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
