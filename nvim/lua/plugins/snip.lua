local ls = require('luasnip')
local set_keymap = require("../utils").set_keymap

ls.add_snippets("all", {
  ls.snippet("shebang", {
    ls.text_node("#!/usr/bin/env -S uv run --script"),
  })
})

-- require('telescope').load_extension('luasnip')
