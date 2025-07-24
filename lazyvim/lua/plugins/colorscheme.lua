return {
  { "sainnhe/gruvbox-material" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    init = function()
      local function is_dark_mode()
        local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
        if not handle then
          return false
        end
        local result = handle:read("*a")
        handle:close()
        return result:match("Dark") ~= nil
      end

      if is_dark_mode() then
        vim.opt.background = "dark"
      else
        vim.opt.background = "light"
      end
    end,
    config = function()
      require("auto-dark-mode").setup()
    end,
  },
}
