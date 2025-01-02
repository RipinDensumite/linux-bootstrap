#!/bin/bash

source ./utils.sh

install_speedtest() {
  if command -v speedtest &>/dev/null; then
    print_info "Speedtest CLI is already installed."
  else
    print_seperator
    print_info "Installing speedtest CLI..."

    sudo apt-get install -y curl

    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    sudo apt-get install -y speedtest
    print_success "Installation completed!"
  fi
}
