local settings = require("config.settings")

local M = {}

function M.build_formatter_map()
  local map = {}
  for ft, cfg in pairs(settings.languages) do
    if cfg.formatters and #cfg.formatters > 0 then
      map[ft] = cfg.formatters
    end
  end
  return map
end

-- On-demand formatting using Conform. Uses default chain with LSP fallback.
function M.format(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or 0
  local ok, conform = pcall(require, "conform")
  if not ok then
    return vim.notify("Conform not available", vim.log.levels.WARN)
  end
  conform.format({ bufnr = bufnr, async = false, lsp_fallback = true })
end

-- Opinionated autofix: run fixers before format when available for the filetype.
function M.autofix(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or 0
  local ok, conform = pcall(require, "conform")
  if not ok then
    return vim.notify("Conform not available", vim.log.levels.WARN)
  end
  local ft = vim.bo[bufnr].filetype
  local chain
  if ft == "python" then
    chain = { "ruff_fix", "ruff_format" }
  elseif ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" or ft == "tsx" then
    chain = { "eslint_d", "prettierd" }
  end
  if chain then
    conform.format({ bufnr = bufnr, async = false, formatters = chain })
  else
    conform.format({ bufnr = bufnr, async = false, lsp_fallback = true })
  end
end

return M
