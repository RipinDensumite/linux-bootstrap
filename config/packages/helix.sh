#!/bin/bash

source ./utils.sh

install_helix() {
    print_separator
    print_info "Installing Helix text editor..."

    # Check if Helix is already installed
    if command -v hx &> /dev/null; then
        print_warning "Helix is already installed."
    else
        # Download the latest Helix release
        print_info "Downloading the latest version of Helix..."
        HELIX_VERSION=$(curl -s "https://api.github.com/repos/helix-editor/helix/releases/latest" | grep -Po '"tag_name": "\K[^\"]*')
        curl -Lo helix.tar.xz "https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/helix-${HELIX_VERSION}-x86_64-linux.tar.xz"

        # Extract and install Helix
        print_info "Extracting Helix..."
        mkdir -p helix-install
        tar -xf helix.tar.xz -C helix-install --strip-components 1

        # Move binaries to the system PATH
        sudo mv helix-install/hx /usr/local/bin/
        print_success "Helix installed successfully."

        # Clean up installation files
        rm -rf helix.tar.xz helix-install
    fi

    # Set up the configuration file
    configure_helix
}

configure_helix() {
    print_separator
    print_info "Configuring Helix..."

    CONFIG_DIR="$HOME/.config/helix"
    CONFIG_FILE="$CONFIG_DIR/config.toml"

    # Create the configuration directory if it doesn't exist
    mkdir -p "$CONFIG_DIR"

    # Write a basic `config.toml` if it doesn't exist
    if [[ -f "$CONFIG_FILE" ]]; then
        print_warning "Helix configuration file already exists at $CONFIG_FILE."
    else
        print_info "Creating a new configuration file at $CONFIG_FILE..."
        cat <<EOF > "$CONFIG_FILE"
# Helix Configuration File
theme = "horizon-dark"

[editor]
line-number = "absolute"
mouse = false

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.file-picker]
hidden = false
EOF
        print_success "Configuration file created at $CONFIG_FILE."
    fi
}
