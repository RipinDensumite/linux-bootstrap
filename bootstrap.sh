#!/bin/bash

# Colors
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Spinner function for visual feedback during installation
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to display section headers
section() {
    echo "${YELLOW}==> $1${RESET}"
}

# Function to display success messages
success() {
    echo "${GREEN}$1${RESET}"
}

# Function to display error messages
error() {
    echo "${RED}$1${RESET}"
}

# Update and upgrade the system
section "Updating system..."
sudo apt-get update > /dev/null 2>&1 && sudo apt-get upgrade -y > /dev/null 2>&1 & spinner
success "System updated."

# List of software to install
PACKAGES_LIST=(
    "git"
    "curl"
    "vim"
    "neovim"
    "htop"
    "nodejs"
    "npm"
    # Add more software as needed
)

# Install required software from apt repositories
section "Installing common packages..."
for package in "${PACKAGES_LIST[@]}"; do
    if dpkg -l | grep -q "^ii  $package"; then
        success "$package is already installed, skipping..."
    else
        section "Installing $package..."
        sudo apt-get install -y $package > /dev/null 2>&1 & spinner
        success "$package installed."
    fi
done
success "Common packages installation completed."

# Check if zsh is installed and change the default shell if necessary
if [ -x "$(command -v zsh)" ]; then
    success "Zsh is already installed."
else
    section "Installing zsh..."
    sudo apt-get install -y zsh > /dev/null 2>&1 & spinner
    success "Zsh installed."
fi

# Check the current shell and change to zsh if it's not set
if [ "$SHELL" != "$(which zsh)" ]; then
    section "Changing shell to zsh..."
    chsh -s $(which zsh) > /dev/null 2>&1 & spinner
    success "Zsh is now the default shell."
else
    success "Zsh is already the default shell."
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    section "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1 & spinner
    success "Oh My Zsh installed."
else
    success "Oh My Zsh is already installed."
fi

install_docker() {
    section "Checking if Docker is installed..."

    # Check if Docker is installed
    if [ -x "$(command -v docker)" ]; then
        success "Docker is already installed."
    else
        section "Installing Docker service..."
        # Add Docker's GPG key and repository
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc > /dev/null 2>&1
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Update repositories and install Docker
        sudo apt-get update > /dev/null 2>&1 & spinner
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin > /dev/null 2>&1 & spinner
        success "Docker installed."

        # Setup Docker (optional)
        section "Starting Docker service..."
        sudo systemctl enable docker > /dev/null 2>&1 & spinner
        sudo systemctl start docker > /dev/null 2>&1 & spinner
        success "Docker service started."
    fi
}

install_docker

# Clean up
section "Cleaning up..."
sudo apt-get autoremove -y > /dev/null 2>&1 & spinner
sudo apt-get clean > /dev/null 2>&1 & spinner
success "Clean-up completed."

echo "${GREEN}All software installed successfully!${RESET}"
