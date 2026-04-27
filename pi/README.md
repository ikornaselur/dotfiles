# Raspberry Pi dotfiles

Minimal Ansible setup that targets a Raspberry Pi over SSH from a control
machine. Installs zsh + oh-my-zsh + powerlevel10k, neovim from AppImage,
a small set of CLI tools via apt, and symlinks the dotfiles in this repo.

Assumes a 64-bit Raspberry Pi OS (Bookworm or newer) with passwordless
`sudo` for the target user.

## Usage

```sh
cd pi/ansible

# All playbooks
just full <host> <user>

# Individual steps
just apt      <host> <user>
just dotfiles <host> <user>
just omz      <host> <user>
just nvim     <host> <user>
just tmux     <host> <user>
```

Or directly:

```sh
ansible-playbook -i '<host>,' -u <user> full.yaml
```
