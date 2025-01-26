#!/bin/bash
clear

source ./config/utils.sh
source ./config/installation_dialog.sh
source ./config/presetup.sh

menu(){
  echo -e "${BLUE}=========================================${NC}"
  echo -e "${CYAN}Select an option:${NC}"
  echo -e "${GREEN}1. Install Packages"
  echo -e "${GREEN}2. Exit"
  echo -e "${BLUE}=========================================${NC}"
}

menu_warning=""

while true
do
  clear
  menu
  echo $menu_warning
  read -p "Enter your choice [1-2]: " choice
  case $choice in
    1) clear && menu_warning="" && packages_dialog ;;
    2) echo "Program exit" && exit 0;;
    *) menu_warning="Please make a correct selection";;
  esac
done
