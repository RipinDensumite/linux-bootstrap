#!/bin/bash

source ./utils.sh

PACKAGES=(
  "git"
  "curl"
  "neovim"
  "zsh"
  "htop"
  "nodejs"
  "npm"
)

install_common_packages() {
  print_separator
  print_info "Installing common packages..."

  for pkg in "${PACKAGES[@]}"; do
    if dpkg -l | grep -qw "$pkg"; then
      print_warning "$pkg is already installed."
    else
      print_info "Installing $pkg..."
      if sudo apt-get install -y "$pkg"; then
        print_success "$pkg installed successfully."
      else
        print_error "Failed to install $pkg."
      fi
    fi
  done
}
