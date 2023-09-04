#!/bin/bash
set -e

# Set up homebrew
echo "Requesting sudo permission for installing homebrew"
sudo echo ""
CI=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo -k  #  Reset sudo timestamp

# Set up ansible with brew
brew install ansible
ansible-galaxy collection install community.general

# Bootstrap with ansible
cd ../ansible
ansible-playbook homebrew.yaml
ansible-playbook dotfiles.yaml
