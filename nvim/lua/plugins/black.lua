local cmd = vim.cmd

cmd("autocmd BufWritePre *.py execute ':Black'")
