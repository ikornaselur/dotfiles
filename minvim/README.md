# minvim

Configuring Vim is ... a rabbit hole. What if we just start fresh and have an AI agent configure based on requests?

Well, this is the result! Is the configuration good? No idea! I didn't spend time on it.

Does it work? For me it does! Do I expect anyone else to use it? No!

## Bootstrap (Linux)

On a fresh Linux box, run:

```sh
./bootstrap.sh
```

It installs Neovim (the `v0.11.7` release tarball), the CLI tools the config expects
(git, ripgrep, fd, node, a C compiler), symlinks this directory to
`~/.config/nvim`, and syncs plugins. It's safe to re-run.

Pin a different Neovim version with `NVIM_VERSION=0.11.7 ./bootstrap.sh`.
