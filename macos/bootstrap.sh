#!/bin/bash
set -e

# Start with the xcode cli tools
xcode-select --install || true

printf "Waiting for Xcode CLI tools to finish installing.."
until xcode-select -p &>/dev/null; do
	printf "."
	sleep 10
done
echo

# Set up homebrew
echo "Requesting sudo permission for installing homebrew"
sudo -v

CI=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
sudo -k #  Reset sudo timestamp

# Set up ansible with brew
brew install ansible
ansible-galaxy collection install community.general

# Clone the repo
git clone https://github.com/ikornaselur/dotfiles.git ~/.dotfiles

cd ~/.dotfiles/macos/ansible

# Bootstrap with ansible
ansible-playbook full.yaml
