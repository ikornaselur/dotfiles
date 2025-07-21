-- -- Go to previous diagnostic
vim.keymap.set("n", "<C-h>", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })

-- Go to next diagnostic
vim.keymap.set("n", "<C-l>", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
