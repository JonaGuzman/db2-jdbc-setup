#!/bin/bash

# Check if script is running with sudo privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run this script with sudo privileges"
    exit 1
fi

echo "Starting WSL environment setup..."

# DNS Configuration
echo "Checking DNS configuration..."
if ! grep -q "nameserver 8.8.8.8" /etc/resolv.conf && ! grep -q "nameserver 8.8.4.4" /etc/resolv.conf; then
    echo "Configuring DNS with Google DNS servers..."
    cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
    echo "DNS configuration updated."
else
    echo "DNS already configured with Google DNS servers. Skipping..."
fi

# Update package list
echo "Updating package list..."
apt-get update

# Install Git if not already installed
echo "Checking Git installation..."
if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    apt-get install -y git
else
    echo "Git is already installed. Skipping..."
fi

# Install Java
echo "Installing OpenJDK 11..."
if ! command -v java &> /dev/null; then
    apt-get install -y openjdk-11-jdk
    if ! grep -q "JAVA_HOME" /etc/profile; then
        echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/profile
        source /etc/profile
    fi
else
    echo "Java is already installed. Skipping..."
fi

# Install NVM and Node
echo "Installing NVM and Node..."
if [ ! -d "$HOME/.nvm" ]; then
    # Download and run NVM installation script
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

    # Add NVM configuration to ~/.bashrc if not already present
    if ! grep -q "NVM_DIR" "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" << 'EOF'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
    fi

    # Source the updated .bashrc
    source "$HOME/.bashrc"

    # Install Node 22 and set as default
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 22
    nvm alias default 22
else
    echo "NVM is already installed. Skipping..."
fi

# Install Cypress dependencies
echo "Installing Cypress dependencies..."
CYPRESS_DEPS="libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libnss3 libxss1 libasound2 libxtst6 xauth xvfb"
for package in $CYPRESS_DEPS; do
    if ! dpkg -l | grep -q "^ii  $package "; then
        apt-get install -y "$package"
    else
        echo "$package is already installed. Skipping..."
    fi
done

# Install node-gyp and its dependencies
echo "Installing node-gyp and its dependencies..."
NODE_GYP_DEPS="build-essential python3 make g++"
for package in $NODE_GYP_DEPS; do
    if ! dpkg -l | grep -q "^ii  $package "; then
        apt-get install -y "$package"
    else
        echo "$package is already installed. Skipping..."
    fi
done

if ! command -v node-gyp &> /dev/null; then
    npm install -g node-gyp
else
    echo "node-gyp is already installed. Skipping..."
fi

echo "Setup complete! Please restart your terminal for all changes to take effect."
