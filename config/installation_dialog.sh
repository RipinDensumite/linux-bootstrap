#!/bin/bash

source ./utils.sh

# Import packages
source ./config/packages/common.sh
source ./config/packages/docker.sh
source ./config/packages/helix.sh

packages_dialog(){
# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
  echo "Installing dialog..."
  sudo apt-get update
  sudo apt-get install -y dialog
fi

# Temporary file to store the dialog results
TEMP_FILE=$(mktemp)

# Menu options with initial selections
OPTIONS=(
  1 "Common software" off
  2 "Docker" off
  3 "Helix" off
)

# Display the menu
dialog --checklist "Select Packages to Install:" 15 40 5 \
  "${OPTIONS[@]}" 2> "$TEMP_FILE"

# Read the selected options
SELECTION=$(cat "$TEMP_FILE")
rm -f "$TEMP_FILE"

# Convert selection to an array
SELECTED_PACKAGES=()
for item in $SELECTION; do
  case $item in
    1) SELECTED_PACKAGES+=("common software") ;;
    2) SELECTED_PACKAGES+=("docker") ;;
    3) SELECTED_PACKAGES+=("helix") ;;
  esac
done

# Display the selected packages and confirm installation
if [[ ${#SELECTED_PACKAGES[@]} -eq 0 ]]; then
  dialog --msgbox "No packages selected. Exiting." 10 30
  clear
else
  dialog --yesno "You selected:\n\n${SELECTED_PACKAGES[*]}\n\nProceed with installation?" 15 40
  RESPONSE=$?
  clear
  if [[ $RESPONSE -ne 0 ]]; then
    echo "Installation canceled."
    exit 0
  fi
fi

# Perform the installations
for package in "${SELECTED_PACKAGES[@]}"; do
  echo "Installing $package..."
  case $package in
    "common software")
      install_common_packages
      ;;
    "docker")
      install_docker
      ;;
    "helix")
      install_helix
      ;;
  esac
  echo "$package installation completed."
done

print_success "All selected packages installed successfully, please press any key to continue."
read -n 1 -s
}
