#!/bin/bash

# Check if dialog is installed                                                                                         
if ! command -v dialog &> /dev/null; then                                                                              
  echo "Installing dialog..."                                                                                          
  sudo apt-get update                                                                                                  
  sudo apt-get install -y dialog                                                                                       
fi 

# Check if curl is installed
if ! command -v curl &> /dev/null; then
  echo "Installing curl..."
  sudo apt update
  sudo apt install -y curl
fi
