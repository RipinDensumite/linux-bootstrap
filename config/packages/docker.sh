#!/bin/bash

source ./utils.sh

install_docker() {
    print_separator
    print_info "Installing Docker and Docker Compose..."

    if command -v docker &> /dev/null; then
        print_warning "Docker is already installed."
    else
        # Docker installation steps
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt-get update
        if sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin; then
            print_success "Docker and Docker Compose installed successfully."
        else
            print_error "Failed to install Docker and Docker Compose."
            return 1
        fi
    fi

    # Verify Docker Compose installation
    if command -v docker-compose &> /dev/null; then
        print_warning "Docker Compose is already installed."
    else
        print_info "Installing Docker Compose (standalone)..."
        DOCKER_COMPOSE_VERSION=$(curl -s "https://api.github.com/repos/docker/compose/releases/latest" | grep -Po '"tag_name": "\K[^\"]*')
        sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        if docker-compose --version &> /dev/null; then
            print_success "Docker Compose installed successfully."
        else
            print_error "Failed to install Docker Compose."
        fi
    fi
}
