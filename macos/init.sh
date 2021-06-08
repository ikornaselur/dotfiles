#!/bin/bash
set -e

# Set up homebrew
echo "Requesting sudo permission for installing homebrew"
sudo echo ""
CI=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo -k  #  Reset sudo timestamp

# Install common apps/utils from homebrew
brew install \
  exa \
  ffmpeg \
  git \
  htop \
  imagemagick \
  neovim \
  pyenv \
  tig \
  tmux \
  wget

brew install --cask \
  alacritty \
  google-chrome \
  spotify \
  slack \
  steam \
  ferdi

# Remove default dock stuff and configure to hide
wget https://raw.githubusercontent.com/kcrawford/dockutil/master/scripts/dockutil -O /tmp/dockutil
chmod +x /tmp/dockutil
/tmp/dockutil --remove all --no-restart
/tmp/dockutil --add "/Applications/Alacritty.app" --no-restart
/tmp/dockutil --add "/Applications/Google Chrome.app" --no-restart
/tmp/dockutil --add "/Applications/Spotify.app" --no-restart
/tmp/dockutil --add "/Applications/Ferdi.app" --no-restart
/tmp/dockutil --add "/Applications/Slack.app" --no-restart
/tmp/dockutil --add "/Applications/Steam.app"


# Set up Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Cargo install apps
~/.cargo/bin/cargo install \
  cargo-edit

# Create folders
mkdir -p ~/.config/alacritty
mkdir -p ~/Projects
git clone https://github.com/ikornaselur/dotfiles.git ~/Projects/dotfiles

# Hook up dot files
ln -s ~/Projects/dotfiles/macos/alacritty.yml ~/.config/alacritty/alacritty.yml

# Configure tmux

# Set up ZSH, oh-my-zsh and powerlevel10k

# Set up Python + Poetry

