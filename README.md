# Personal Linux Bootstrap Script

This repository contains a bash script designed to automate the setup of a freshly installed Linux environment by installing commonly used packages, setting up Docker, and configuring Zsh with Oh My Zsh. The script is highly customizable and ensures that essential tools and configurations are installed without manual intervention.

## Requirements

- This script is designed for Debian-based distributions such as Ubuntu. It may need to be modified for other distributions.
- Sudo privileges is required to run this script successfully.

## Features

- **Automatic System Update**: The script updates and upgrades your system before installing any software.
- **Common Package Installation**: Installs a list of essential packages such as `git`, `curl`, `vim`, `zsh`, and others. You can easily customize this list to include additional software.
- **Zsh and Oh My Zsh Setup**: Automatically installs Zsh and sets it as the default shell. Oh My Zsh is installed for a more powerful shell experience.
- **Docker Installation**: Checks if Docker is already installed, and if not, installs Docker with all necessary dependencies and starts the service.
- **Visual Installation Feedback**: The script provides clear visual feedback during installation, using colored text and a progress spinner for a smoother user experience.
- **Clean Up**: Once the installation is complete, the system is cleaned of unnecessary packages and caches.

## Usage

### 1. Clone the Repository

First, clone this repository to your local machine:

```bash
git clone https://github.com/yourusername/your-repo-name.git
```

### 2. Make the Script Executable

Before running the script, ensure it has executable permissions:

```bash
chmod +x setup.sh
```

### 3. Run the Script

Run the `setup.sh` script with the following command:

```bash
./setup.sh
```

This will start the installation process, which includes:
- Updating and upgrading the system.
- Installing the listed packages.
- Setting up Zsh and Oh My Zsh.
- Installing Docker (if not already installed).
- Cleaning up the system post-installation.

### 4. Customizing the Script

You can modify the list of packages to be installed by editing the `PACKAGES_LIST` in the script. For example, to add more packages like `python3` or `tmux`, update the list like this:

```bash
PACKAGES_LIST=(
    "git"
    "curl"
    "vim"
    "zsh"
    "htop"
    "nodejs"
    "npm"
    "python3"
    "tmux"
)
```

### 5. Adding More Functionality

If you need additional setup steps, such as installing custom software or configuring dotfiles, you can add those steps to the script under the respective sections.

For example, to install Java:

```bash
# Install Java
echo "Installing Java..."
sudo apt-get install -y openjdk-11-jdk
```
