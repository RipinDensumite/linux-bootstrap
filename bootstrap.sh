#!/bin/bash

# Define colors for visual output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print messages with colors
print_info() {
    echo -e "${CYAN}* ${1}${NC}"
}

print_success() {
    echo -e "${GREEN}✓ ${1}${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ ${1}${NC}"
}

print_error() {
    echo -e "${RED}✗ ${1}${NC}"
}

print_separator() {
    echo -e "${BLUE}=========================================${NC}"
}

# Function to update and upgrade the system
update_system() {
    print_separator
    print_info "Updating system..."
    sudo apt-get update && sudo apt-get upgrade -y
}

# Function to install common packages
install_packages() {
    print_separator
    print_info "Installing common packages..."
    PACKAGES_LIST=(
        "git"
        "curl"
        "vim"
        "neovim"
        "zsh"
        "htop"
        "nodejs"
        "npm"
        # Add more software as needed
    )

    for package in "${PACKAGES_LIST[@]}"; do
        if dpkg -l | grep -qw "$package"; then
            print_warning "$package is already installed. Skipping installation."
        else
            print_info "Installing $package..."
            if sudo apt-get install -y "$package"; then
                print_success "$package installed successfully."
            else
                print_error "Failed to install $package."
            fi
        fi
    done
    print_success "Common packages installation completed."
}

# Function to change shell to zsh and configure theme
configure_zsh() {
    print_separator
    print_info "Configuring Zsh..."
    
    if command -v zsh &> /dev/null; then
        print_warning "Zsh is already installed. Skipping configuration."
    else
        print_info "Changing shell to zsh..."
        if chsh -s "$(which zsh)"; then
            print_success "Zsh has been successfully set as default shell."
        else
            print_error "Failed to change shell to zsh."
        fi
    fi

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Installing Oh My Zsh..."
        if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
            print_success "Oh My Zsh has been successfully installed."
        else
            print_error "Failed to install Oh My Zsh."
        fi
    else
        print_warning "Oh My Zsh is already installed. Skipping installation."
    fi

    # Change Zsh theme to sunaku
    print_info "Changing Zsh theme to 'sunaku'..."
    if grep -q 'ZSH_THEME="sunaku"' ~/.zshrc; then
        print_warning "Theme 'sunaku' is already set."
    else
        sed -i.bak 's/^ZSH_THEME=".*"/ZSH_THEME="sunaku"/' ~/.zshrc
        print_success "Zsh theme changed to 'sunaku'."
    fi
}

# Function to install Docker
install_docker() {
    print_separator
    print_info "Installing Docker service..."

    if command -v docker &> /dev/null; then
        print_warning "Docker is already installed. Skipping installation."
    else
        # Add Docker's GPG key and repository
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Update repositories and install Docker
        sudo apt-get update
        if sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin; then
            print_success "Docker installed successfully."
        else
            print_error "Failed to install Docker."
        fi

        # Setup Docker
        print_info "Starting Docker service..."
        sudo systemctl enable docker
        sudo systemctl start docker
    fi
}

# Function to install LazyGit
install_lazygit() {
    print_separator
    print_info "Installing LazyGit..."
    
    if command -v lazygit &> /dev/null; then
        print_warning "LazyGit is already installed. Skipping installation."
    else
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        if sudo install lazygit /usr/local/bin; then
            print_success "LazyGit has been installed successfully."
        else
            print_error "Failed to install LazyGit."
        fi
        rm lazygit.tar.gz lazygit # Clean up installation files
    fi
}

# Function to clean up the system
clean_up() {
    print_separator
    print_info "Cleaning up..."
    sudo apt-get autoremove -y
    sudo apt-get clean
}

# Main script execution
print_separator
print_info "Starting installation process..."

update_system
install_packages
configure_zsh
install_docker
install_lazygit
clean_up

print_success "All software installed successfully."
print_separator
