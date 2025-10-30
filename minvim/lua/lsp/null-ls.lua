local M = {}

local settings = require("config.settings")

local function get_builtin(null_ls, category, name)
  local ok, builtin = pcall(function()
    return null_ls.builtins[category][name]
  end)
  if ok and builtin then
    return builtin
  end
end

function M.setup()
  local null_ls = require("null-ls")
  local sources = {}
  local seen = {}

  local function add_builtin(category, name)
    if seen[category .. name] then
      return
    end
    local builtin = get_builtin(null_ls, category, name)
    if builtin then
      table.insert(sources, builtin)
      seen[category .. name] = true
    end
  end

  for _, cfg in pairs(settings.languages) do
    local nl = cfg.null_ls or {}
    for _, formatter in ipairs(nl.formatting or {}) do
      add_builtin("formatting", formatter)
    end
    for _, diagnostic in ipairs(nl.diagnostics or {}) do
      add_builtin("diagnostics", diagnostic)
    end
    for _, code_action in ipairs(nl.code_actions or {}) do
      add_builtin("code_actions", code_action)
    end
  end

  null_ls.setup({
    border = "rounded",
    sources = sources,
  })
end

return M
