#!/bin/bash

set -ouex pipefail

read -rp "Enter your GITHUB USER: " GITHUBUSER
if [ ! -d ~/.dotfiles-private ] && [ ! -d ./dotfiles-cli ]; then
  read -rp "Enter your GITHUB PAT: " GITHUBPAT
fi

# Function to setup docker
setup_docker() {
  echo "Setup docker..."

  getent group docker || {
    echo "docker group does not exist"
    return 0
  }
  groups
  sudo usermod -aG docker "$USER"
}

# Function to setup dotfiles-cli
setup_dotfiles_cli() {
  echo "Setup dotfiles-cli..."

  if [ -d ~/.dotfiles-cli ]; then
    echo "dotfiles-cli repository exists...."
  else
    echo "Cloning dotfiles-cli repository..."
    if ! git clone "https://$GITHUBUSER:$GITHUBPAT@github.com/$GITHUBUSER/.dotfiles-cli.git" ~/.dotfiles-cli; then
      echo "Failed to clone dotfiles-cli repository"
      exit 1
    fi
  fi

  cd ~/.dotfiles-cli || {
    echo "Failed to enter .dotfiles-cli directory"
    exit 1
  }
  git pull
  echo "Initializing and updating submodules..."
  git submodule update --init || {
    echo "Failed to update submodules"
    exit 1
  }

  if [[ "$(hostnamectl status --json=short | jq -r .DefaultHostname)" =~ ^(bazzite)$ ]]; then
    ansible-playbook ansible/fsa.yml -D --ask-become-pass
    stow ghostty gammastep autostart || {
      echo "Failed to stow dotfiles"
      exit 1
    }
  fi
  stow fish starship nvim.astro brew || {
    echo "Failed to stow dotfiles"
    exit 1
  }
  if command -v brew &>/dev/null; then
    echo "Homebrew is installed."
  else
    echo "Homebrew is not installed."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >>~/.bashrc
    # shellcheck disable=SC2016
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >>~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
  fi
  brew trust derailed/k9s
  brew trust aws/tap
  brew trust dgunzy/tap
  brew trust fluxcd/tap
  brew trust hashicorp/tap
  brew trust valkyrie00/bbrew
  brew install git-lfs
  #brew bundle check --file ~/Brewfile || {
  #  brew bundle install --file ~/Brewfile --verbose
  #}

  git remote set-url origin "git@github.com:$GITHUBUSER/.dotfiles-cli.git"
  git remote -v
}

# Function to setup dotfiles-private
setup_dotfiles_private() {
  echo "Setup dotfiles-private..."

  if [ -d ~/.dotfiles-private ]; then
    echo "dotfiles-private repository exists...."
  else
    echo "Cloning dotfiles-private repository..."
    if ! git clone "https://$GITHUBUSER:$GITHUBPAT@github.com/$GITHUBUSER/.dotfiles-private.git" ~/.dotfiles-private; then
      echo "Failed to clone dotfiles-private repository"
      exit 1
    fi
  fi

  cd ~/.dotfiles-private || {
    echo "Failed to enter .dotfiles-private directory"
    exit 1
  }
  git pull

  ansible-playbook ansible/fsa.yml -D --ask-become-pass --ask-vault-pass

  git remote set-url origin "git@github.com:$GITHUBUSER/.dotfiles-private.git"
  git remote -v
}

# Function to change default shell to fish
change_shell() {
  echo "Change default shell to fish..."

  if ! sudo usermod -s /bin/fish "$USER"; then
    echo "Failed to change shell"
    exit 1
  fi
}

# Main script execution
cd ~ || exit 1
setup_docker
setup_dotfiles_cli
setup_dotfiles_private
change_shell

git config --global user.name "$GITHUBUSER"
git config --global user.email "$GITHUBUSER@users.noreply.github.com"
git config --global core.editor nvim
git lfs install
mkdir -p ~/git
#nvim --headless +q

echo ".dotfiles.sh script complete!"
exit 0
