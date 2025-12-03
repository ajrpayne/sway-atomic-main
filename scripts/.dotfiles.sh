#!/bin/bash

set -ouex pipefail

# Function to set up SSH
setup_ssh() {
  echo "Setting up SSH..."

  mkdir -p ~/.ssh
  chmod 0700 ~/.ssh
}

# Function to set up docker
setup_docker() {
  echo "Setting up docker..."

  groups
  sudo usermod -aG docker "$USER"
  sudo systemctl enable docker.socket
}

# Function to set up dotfiles
setup_dotfiles() {
  echo "Setting up dotfiles..."

  if [ -d ~/.dotfiles-cli ]; then
    echo "dotfiles repository exists...."
  else
      echo "Cloning dotfiles repository..."
    if ! git clone https://github.com/ajrpayne/.dotfiles-cli.git ~/.dotfiles-cli; then
      echo "Failed to clone dotfiles repository"
      exit 1
    fi
  fi

  cd ~/.dotfiles-cli || {
    echo "Failed to enter .dotfiles-cli directory"
    exit 1
  }

  echo "Initializing and updating submodules..."
  git submodule update --init || {
    echo "Failed to update submodules"
    exit 1
  }

  echo "Stowing dotfiles..."
  stow fish starship nvim.astro || {
    echo "Failed to stow dotfiles"
    exit 1
  }

  cd ~ || exit 1
}

# Function to change the default shell to fish
change_shell() {
  echo "Changing default shell to fish..."

  if ! chsh -s /bin/fish; then
    echo "Failed to change shell"
    exit 1
  fi
}

# Main script execution
cd ~ || exit 1
setup_ssh
setup_docker
setup_dotfiles
change_shell

echo "Setup complete!"
exit 0