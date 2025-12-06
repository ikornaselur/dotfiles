return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1000,
    -- Only enable auto dark mode on macOS to avoid issues on remote Linux
    cond = function()
      local uv = vim.uv or vim.loop
      return uv.os_uname().sysname == "Darwin"
    end,
    config = function()
      local auto_dark_mode = require("auto-dark-mode")
      auto_dark_mode.setup({
        update_interval = 1000,
        set_dark_mode = function()
          vim.opt.background = "dark"
          vim.cmd.colorscheme("gruvbox-material")
        end,
        set_light_mode = function()
          vim.opt.background = "light"
          vim.cmd.colorscheme("gruvbox-material")
        end,
      })
      auto_dark_mode.init()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ts_settings = require("config.settings").treesitter
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = ts_settings.ensure_installed,
      })
    end,
  },
  -- Sticky context of current function/class at the top of the window.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    cond = function()
      local ok, settings = pcall(require, "config.settings")
      if not ok then
        return true
      end
      local ctx = settings.ui and settings.ui.treesitter_context
      if ctx == nil then
        return true
      end
      if type(ctx) ~= "table" then
        return ctx ~= false
      end
      return ctx.enabled ~= false
    end,
    opts = function()
      local cfg = {}
      local ok, settings = pcall(require, "config.settings")
      if ok and settings.ui and settings.ui.treesitter_context then
        cfg = settings.ui.treesitter_context
      end
      if type(cfg) ~= "table" then
        cfg = {}
      end
      return {
        enable = true,
        max_lines = cfg.max_lines or 3,
        multiline_threshold = cfg.multiline_threshold or 20,
        trim_scope = cfg.trim_scope or "outer",
        mode = cfg.mode or "cursor",
        separator = cfg.separator, -- nil disables separator line
        zindex = cfg.zindex or 20,
      }
    end,
    config = function(_, opts)
      require("treesitter-context").setup(opts)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = function(_, opts)
      local default_rules = require("which-key.icons").rules
      local custom_icons = {
        { pattern = "^tabs?", icon = "󰓩 ", color = "purple" },
        { pattern = "buffer", icon = "󰈔", color = "cyan" },
        { pattern = "code", icon = " ", color = "orange" },
        { pattern = "debug", icon = "󰃤 ", color = "red" },
        { pattern = "file", icon = "󰈙 ", color = "cyan" },
        { pattern = "find", icon = " ", color = "green" },
        { pattern = "^git", icon = "󰊢 ", color = "red" },
        { pattern = "^lsp", icon = " ", color = "blue" },
        { pattern = "goto", icon = "󰯸 ", color = "blue" },
        { pattern = "^prev", icon = " ", color = "yellow" },
        { pattern = "^next", icon = " ", color = "yellow" },
        { pattern = "search", icon = " ", color = "green" },
        { pattern = "tests?", icon = "󰙨 ", color = "purple" },
        { pattern = "diagnostic", icon = "󱖫 ", color = "green" },
        { pattern = "quickfix", icon = "󰁨 ", color = "yellow" },
        { pattern = "^ui$", icon = "󰙵 ", color = "cyan" },
        { pattern = "fold", icon = "󱃖 ", color = "cyan" },
        { pattern = "session", icon = " ", color = "azure" },
        { pattern = "quit", icon = "󰈆 ", color = "red" },
        { pattern = "format", icon = " ", color = "cyan" },
        { pattern = "window", icon = " ", color = "blue" },
        { pattern = "explorer", icon = " ", color = "blue" },
        { pattern = "terminal", icon = " ", color = "red" },
        { pattern = "context", icon = " ", color = "orange" },
        { pattern = "background", icon = " ", color = "purple" },
        { pattern = "theme", icon = " ", color = "yellow" },
        { pattern = "toggle", icon = " ", color = "yellow" },
        { pattern = "help", icon = "󰞋 ", color = "blue" },
        { pattern = "save", icon = " ", color = "azure" },
        { pattern = "live grep", icon = " ", color = "green" },
        { pattern = "terminal", icon = " ", color = "red" },
      }

      opts.preset = "helix"
      opts.icons = vim.tbl_extend("force", {
        separator = "·",
        group = " ",
        rules = vim.list_extend(custom_icons, default_rules),
      }, opts.icons or {})
      opts.spec = {
        {
          mode = { "n", "x" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>q", group = "quit/session" },
          { "<leader>t", group = "tests" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "<leader>z", group = "fold" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "<leader>w", proxy = "<c-w>", group = "windows" },
          { "z", group = "fold" },
        },
      }
      return opts
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps",
      },
      {
        "<C-w><Space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window controls",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      local ok, extras = pcall(require, "which-key.extras")
      if ok then
        wk.add({
          {
            "<leader>b",
            expand = extras.expand.buf,
          },
          {
            "<leader>w",
            proxy = "<c-w>",
            expand = extras.expand.win,
          },
        }, { mode = { "n", "x" }, notify = false })
      end
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },
  {
    "smoka7/hop.nvim",
    version = false,
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
    config = function(_, opts)
      local hop = require("hop")
      hop.setup(opts)
      vim.keymap.set("n", "f", function()
        hop.hint_words()
      end, { desc = "Hop to word" })
    end,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ["Add Cursor Down"] = "<C-j>",
        ["Add Cursor Up"] = "<C-k>",
        ["Find Under"] = "<C-n>",
        ["Skip Region"] = "<C-q>",
      }
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      shade_terminals = false,
      float_opts = { border = "rounded" },
    },
    config = function(_, opts)
      local toggleterm = require("toggleterm")
      toggleterm.setup(opts)

      vim.keymap.set({ "n", "t" }, "<C-\\>", function()
        vim.cmd("ToggleTerm direction=float")
      end, { desc = "Terminal (float)", silent = true })

      -- Terminal-mode quality of life: quick normal mode + window navigation.
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode", silent = true })
      vim.keymap.set(
        "t",
        "<C-h>",
        [[<C-\><C-n><C-w>h]],
        { desc = "Terminal: go left", silent = true }
      )
      vim.keymap.set(
        "t",
        "<C-j>",
        [[<C-\><C-n><C-w>j]],
        { desc = "Terminal: go down", silent = true }
      )
      vim.keymap.set(
        "t",
        "<C-k>",
        [[<C-\><C-n><C-w>k]],
        { desc = "Terminal: go up", silent = true }
      )
      vim.keymap.set(
        "t",
        "<C-l>",
        [[<C-\><C-n><C-w>l]],
        { desc = "Terminal: go right", silent = true }
      )

      -- In terminal windows, keep Ctrl-l usable while in insert/terminal mode to clear.
      vim.api.nvim_create_autocmd("TermOpen", {
        desc = "Terminal buffer keymaps",
        pattern = "term://*",
        callback = function(ev)
          local buf = ev.buf
          local function send_ctrl_l()
            local job = vim.b[buf].terminal_job_id
            if job then
              pcall(vim.api.nvim_chan_send, job, "\x0c")
            end
          end
          vim.keymap.set(
            "t",
            "<C-l>",
            send_ctrl_l,
            { buffer = buf, desc = "Terminal: clear", silent = true }
          )
        end,
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      select = {
        backend = { "telescope", "builtin" },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Close non-pinned" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Close buffers right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close buffers left" },
      { "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "[B", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer left" },
      { "]B", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer right" },
    },
    opts = function()
      local icons = {
        diagnostics = { error = "", warn = "" },
      }
      return {
        options = {
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
          close_command = function(n)
            vim.schedule(function()
              pcall(vim.api.nvim_buf_delete, n, { force = false })
            end)
          end,
          right_mouse_command = function(n)
            vim.schedule(function()
              pcall(vim.api.nvim_buf_delete, n, { force = false })
            end)
          end,
          diagnostics_indicator = function(_, _, diag)
            local ret = {}
            if diag.error and diag.error > 0 then
              table.insert(ret, icons.diagnostics.error .. diag.error)
            end
            if diag.warning and diag.warning > 0 then
              table.insert(ret, icons.diagnostics.warn .. diag.warning)
            end
            return table.concat(ret, " ")
          end,
          offsets = {
            {
              filetype = "snacks_explorer",
              text = "Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.minvim_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = " "
      else
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local icons = {
        diagnostics = {
          error = " ",
          warn = " ",
          info = " ",
          hint = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      }

      vim.o.laststatus = vim.g.minvim_laststatus or 3

      local function root_dir()
        local cwd = vim.fn.getcwd()
        if not cwd or cwd == "" then
          return ""
        end
        return "  " .. vim.fn.fnamemodify(cwd, ":t")
      end

      local function pretty_path()
        local buf = vim.api.nvim_buf_get_name(0)
        if buf == "" then
          return "[No Name]"
        end
        local cwd = vim.fn.getcwd()
        local path = vim.fn.fnamemodify(buf, ":p")
        if cwd ~= "" then
          cwd = vim.fs.normalize(cwd)
          path = vim.fs.normalize(path)
          if path:sub(1, #cwd) == cwd then
            local relative = path:sub(#cwd + 2)
            if relative ~= "" then
              return relative
            end
          end
        end
        return vim.fn.fnamemodify(buf, ":.")
      end

      local function navic_location()
        local ok, navic = pcall(require, "nvim-navic")
        if not ok or not navic.is_available() then
          return ""
        end
        return navic.get_location()
      end

      local function noice_status(kind)
        local ok, status = pcall(function()
          local api = require("noice").api.status[kind]
          if api.has() then
            return api.get()
          end
        end)
        if ok and status then
          return status
        end
        return ""
      end

      local function has_noice(kind)
        local ok, present = pcall(function()
          local api = require("noice").api.status[kind]
          return api.has()
        end)
        return ok and present
      end

      local function lazy_updates()
        local ok, status = pcall(require, "lazy.status")
        if not ok or not status.has_updates() then
          return ""
        end
        return status.updates()
      end

      return {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            root_dir,
            {
              "diagnostics",
              symbols = icons.diagnostics,
              update_in_insert = false,
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { pretty_path },
            {
              navic_location,
              cond = function()
                local ok, navic = pcall(require, "nvim-navic")
                return ok and navic.is_available()
              end,
            },
          },
          lualine_x = {
            {
              function()
                return noice_status("command")
              end,
              cond = function()
                return has_noice("command")
              end,
            },
            {
              function()
                return noice_status("mode")
              end,
              cond = function()
                return has_noice("mode")
              end,
            },
            {
              lazy_updates,
              cond = function()
                local ok, status = pcall(require, "lazy.status")
                return ok and status.has_updates()
              end,
            },
            {
              "diff",
              symbols = icons.git,
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "quickfix" },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*:]],
      },
      search = {
        pattern = [[\b(KEYWORDS):]],
      },
    },
  },
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts = opts or {}
      local indent_cfg = {}
      local ok, settings = pcall(require, "config.settings")
      if ok and settings.ui and settings.ui.indent_guides then
        indent_cfg = settings.ui.indent_guides
      end
      if type(indent_cfg) ~= "table" then
        indent_cfg = { enabled = indent_cfg }
      end

      local provider = indent_cfg.provider or "snacks"
      local enabled = indent_cfg.enabled ~= false
      local scope_enabled = indent_cfg.scope ~= false
      local animate_enabled = indent_cfg.animate ~= false

      opts.explorer = vim.tbl_deep_extend("force", { enabled = true }, opts.explorer or {})
      opts.input = vim.tbl_deep_extend("force", { enabled = false }, opts.input or {})
      opts.notifier = vim.tbl_deep_extend("force", { enabled = false }, opts.notifier or {})
      opts.scope =
        vim.tbl_deep_extend("force", { enabled = scope_enabled and enabled }, opts.scope or {})
      opts.words = vim.tbl_deep_extend("force", { enabled = false }, opts.words or {})

      opts.indent = vim.tbl_deep_extend("force", {
        enabled = provider == "snacks" and enabled,
        indent = {
          enabled = true,
          char = "│",
          only_scope = false,
        },
        animate = {
          enabled = animate_enabled and enabled,
        },
        scope = {
          enabled = scope_enabled and enabled,
          char = "│",
        },
      }, opts.indent or {})

      return opts
    end,
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)
      if
        snacks.config.scope
        and snacks.config.scope.enabled
        and snacks.scope
        and snacks.scope.enable
      then
        snacks.scope.enable()
      end
      if
        snacks.config.indent
        and snacks.config.indent.enabled
        and snacks.indent
        and snacks.indent.enable
      then
        snacks.indent.enable()
      end
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    cond = function()
      local ok, settings = pcall(require, "config.settings")
      if not ok then
        return false
      end
      local indent = settings.ui and settings.ui.indent_guides
      if indent == nil then
        return true
      end
      if type(indent) ~= "table" then
        return indent ~= false
      end
      if indent.enabled == false then
        return false
      end
      local provider = indent.provider or "snacks"
      return provider ~= "snacks"
    end,
    opts = function()
      local indent_cfg = {}
      local ok, settings = pcall(require, "config.settings")
      if ok and settings.ui and settings.ui.indent_guides then
        indent_cfg = settings.ui.indent_guides
      end
      if type(indent_cfg) ~= "table" then
        indent_cfg = {}
      end

      local scope_enabled = indent_cfg.scope ~= false

      return {
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          enabled = scope_enabled,
          show_start = false,
          show_end = false,
          highlight = "IblScope",
        },
        exclude = {
          filetypes = {
            "dashboard",
            "help",
            "lazy",
            "mason",
            "neo-tree",
            "snacks_dashboard",
            "snacks_notif",
            "snacks_terminal",
            "snacks_win",
            "toggleterm",
            "Trouble",
            "trouble",
          },
        },
      }
    end,
    config = function(_, opts)
      local ok, hooks = pcall(require, "ibl.hooks")
      if ok then
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          local hl = vim.api.nvim_get_hl(0, { name = "Function", link = false })
          if hl and hl.fg then
            vim.api.nvim_set_hl(0, "IblScope", { fg = hl.fg, nocombine = true })
          end
        end)
      end
      require("ibl").setup(opts)
    end,
  },
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      highlight = true,
      separator = "  ",
    },
    config = function(_, opts)
      require("nvim-navic").setup(opts)
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    config = function(_, opts)
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
}
