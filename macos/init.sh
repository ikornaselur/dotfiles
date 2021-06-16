#!/bin/bash
set -e

# Set up homebrew
echo "Requesting sudo permission for installing homebrew"
sudo echo ""
CI=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo -k  #  Reset sudo timestamp

# Install common apps/utils from homebrew
brew install \
  autojump \
  direnv \
  exa \
  ffmpeg \
  fzf \
  git \
  git-delta \
  hammerspoon \
  htop \
  hub \
  imagemagick \
  jq \
  mosh \
  nodejs \
  pyenv \
  ripgrep \
  rust-analyzer \
  tig \
  tmux \
  wget \
  zsh

# Install nightly neovim for v0.5
brew install --head luajit
brew install --head neovim

brew tap homebrew/cask-fonts
brew install --cask \
  alacritty \
  bettertouchtool \
  dashlane \
  docker \
  ferdi \
  google-chrome \
  gpg-tools \
  little-snitch \
  rectangle \
  slack \
  spotify \
  steam

# Remove default dock stuff and configure to hide
wget https://raw.githubusercontent.com/kcrawford/dockutil/8a16df86e98502e2e22af86a82b54aa20f6d6fca/scripts/dockutil -O /tmp/dockutil
chmod +x /tmp/dockutil
/tmp/dockutil --remove all --no-restart
/tmp/dockutil --add "/Applications/Alacritty.app" --no-restart
/tmp/dockutil --add "/Applications/Google Chrome.app" --no-restart
/tmp/dockutil --add "/Applications/Spotify.app" --no-restart
/tmp/dockutil --add "/Applications/Ferdi.app" --no-restart
/tmp/dockutil --add "/Applications/Slack.app" --no-restart
/tmp/dockutil --add "/Applications/Steam.app" --no-restart
defaults write com.apple.Dock autohide -bool TRUE; killall Dock


# Set up Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Cargo install apps
~/.cargo/bin/cargo install \
  cargo-edit \
  litime

# Set up Python + Poetry
VERSION27=`pyenv install --list | grep -E "^\s+2.7.\d+$" | tail -1 | tr -d '[:space:]'`
VERSION39=`pyenv install --list | grep -E "^\s+3.9.\d+$" | tail -1 | tr -d '[:space:]'`
pyenv install ${VERSION27}
pyenv install ${VERSION39}
pyenv global ${VERSION39} ${VERSION27}
~/.pyenv/shims/pip install --upgrade pip
~/.pyenv/shims/pip install \
  black \
  flake8 \
  ipython \
  isort \
  mypy \
  poetry \
  pynvim

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
nvm install --lts
npm install -g \
  bash-language-server \
  pyright \
  sql-language-server \
  typescript \
  typescript-language-server \
  vim-language-server \
  vls yaml-language-server \
  vscode-langservers-extracted


# Install fzf
$(brew --prefix)/opt/fzf/install --all

# Create folders
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/nvim
mkdir -p ~/Projects
mkdir -p ~/.hammerspoon
git clone https://github.com/ikornaselur/dotfiles.git ~/Projects/dotfiles

# Set up alacritty
ln -s ~/Projects/dotfiles/macos/alacritty.yml ~/.config/alacritty/alacritty.yml

wget https://github.com/asmagill/hs._asm.undocumented.spaces/releases/download/v0.5/spaces-v0.5.tar.gz -O /tmp/spaces.tar.gz
tar -zxvf /tmp/spaces.tar.gz -C ~/.hammerspoon/
ln -s ~/Projects/dotfiles/macos/hammerspoon.init.lua ~/.hammerspoon/init.lua

# Install Fira Code font
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fira%20Code%20Retina%20Nerd%20Font%20Complete.ttf -O "/Library/Fonts/Fira Code.ttf"

# Configure tmux
ln -s ~/Projects/dotfiles/tmux.conf ~/.tmux.conf

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# Set up ZSH and oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
rm ~/.zshrc
ln -s ~/Projects/dotfiles/macos/zshrc ~/.zshrc
touch ~/.zshrc.extra
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
chmod g-w,o-w /usr/local/share/zsh
chmod g-w,o-w /usr/local/share/zsh/site-functions

# Set up powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Link the powerlevel10k config
ln -s ~/Projects/dotfiles/macos/p10k.zsh ~/.p10k.zsh

# Set up neovim
ln -s ~/Projects/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -s ~/Projects/dotfiles/nvim/lua ~/.config/nvim/lua
git clone --depth=1 https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
nvim +PaqInstall
