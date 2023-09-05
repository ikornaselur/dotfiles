#!/bin/bash
set -e

# Start with the xcode cli tools
xcode-select --install

# Set up homebrew
echo "Requesting sudo permission for installing homebrew"
sudo echo ""
CI=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo -k  #  Reset sudo timestamp

# Set up ansible with brew
brew install ansible
ansible-galaxy collection install community.general

# Clone the repo 
git clone https://github.com/ikornaselur/dotfiles.git --branch ans ~/.dotfiles 

cd ~/.dotfiles/macos/ansible

# Bootstrap with ansible
ansible-playbook homebrew.yaml
ansible-playbook dotfiles.yaml
