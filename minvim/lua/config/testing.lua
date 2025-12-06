local M = {}

local function get_neotest()
  local ok, neotest = pcall(require, "neotest")
  if not ok then
    vim.notify("neotest not available", vim.log.levels.WARN)
    return nil
  end
  return neotest
end

function M.run_nearest()
  local neotest = get_neotest()
  if not neotest then
    return
  end
  neotest.run.run()
end

function M.run_file()
  local neotest = get_neotest()
  if not neotest then
    return
  end
  neotest.run.run(vim.fn.expand("%"))
end

function M.run_project()
  local neotest = get_neotest()
  if not neotest then
    return
  end
  local uv = vim.uv or vim.loop
  local cwd = (uv and uv.cwd and uv.cwd()) or vim.fn.getcwd()
  neotest.run.run(cwd)
end

function M.toggle_summary()
  local neotest = get_neotest()
  if not neotest then
    return
  end
  neotest.summary.toggle()
end

return M
