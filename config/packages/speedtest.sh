#!/bin/bash

source ./utils.sh

install_speedtest() {
  print_separator
  print_info "Installing speedtest cli..."

  sudo apt-get install curl
  curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
  sudo apt-get install speedtest -y
}
