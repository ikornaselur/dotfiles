#!/bin/sh
set -e

apt-get update
apt-get --assume-yes upgrade

pkg up -y
pkg install -y neovim tmux nodejs python zsh git tig exa file mosh ripgrep hub perl git-delta

# Clone dotfiles
mkdir projects
git clone https://github.com/ikornaselur/dotfiles projects/dotfiles

#########
# Shell #
#########

# Set up oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# Link the .zsh config
rm ~/.zshrc
ln -s ~/projects/dotfiles/termux/zshrc ~/.zshrc

# Set up powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Link the powerlevel10k config
ln -s ~/projects/dotfiles/termux/p10k.zsh ~/.p10k.zsh

# Set default shell
chsh -s zsh

#######
# Git #
#######

# Base git config
cat <<EOF >> ~/.gitconfig
[pull]
  rebase = true
[diff]
  colorMoved = plain
[core]
  pager = delta --plus-color="#012800" --minus-color="#340001"
EOF

##########
# Python #
##########

python -m pip install poetry black mypy ipython isort pynvim flake8

##########
# NodeJS #
##########

npm install -g yarn

########
# Tmux #
########

# Link the tmux conf
ln -s ~/projects/dotfiles/termux/tmux.conf ~/.tmux.conf

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

##########
# Termux #
##########
# Clear default motd
rm /data/data/com.termux/files/usr/etc/motd

# Termux properties
cat <<EOF >> ~/.termux/termux.properties
extra-keys = [ \
 ['ESC','|','/','-','UP', 'BKSP', '"'], \
 ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT', '%'] \
]
EOF

# Font
curl -fLo ~/.termux/font.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf

#######
# FZF #
#######

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

#######
# Vim #
#######

# Set up neovim config
mkdir -p .config/nvim
ln -s ~/projects/dotfiles/nvim/init.vim ~/.config/nvim/init.vim

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install neovim plugins
nvim +'PlugInstall --sync' +qall

echo "All done! Restart Termux..."
