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
  git \
  htop \
  hub \
  imagemagick \
  neovim \
  nodejs \
  pyenv \
  ripgrep \
  tig \
  tmux \
  wget \
  zsh

brew tap homebrew/cask-fonts
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
  cargo-edit \
  litime

# Set up Python + Poetry
VERSION27=`pyenv install --list | grep -E "^\s+2.7.\d+$" | tail -1 | tr -d '[:space:]'`
VERSION39=`pyenv install --list | grep -E "^\s+3.9.\d+$" | tail -1 | tr -d '[:space:]'`
pyenv install ${VERSION27}
pyenv install ${VERSION39}
pyenv global ${VERSION39} ${VERSION27}
pip install --upgrade pip
pip install \
  black \
  flake8 \
  ipython \
  isort \
  mypy \
  poetry \
  pynvim

# Create folders
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/nvim
mkdir -p ~/Projects
git clone https://github.com/ikornaselur/dotfiles.git ~/Projects/dotfiles

# Hook up dotfiles
ln -s ~/Projects/dotfiles/macos/alacritty.yml ~/.config/alacritty/alacritty.yml

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
compaudit | xargs chmod g-w,o-w

# Set up powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Link the powerlevel10k config
ln -s ~/Projects/dotfiles/macos/p10k.zsh ~/.p10k.zsh

# Set up neovim
ln -s ~/Projects/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -s ~/Projects/dotfiles/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim \
  --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +'PlugInstall --sync' +qall
