#!/bin/bash
# setup-wsl.sh - Save this as setup-wsl.sh

# Create the sudo script
cat > setup-wsl-sudo.sh << 'EOF'
#!/bin/bash

# Check if script is running with sudo privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run this script with sudo privileges"
    exit 1
fi

echo "Starting WSL environment setup (system packages)..."

# DNS Configuration
echo "Checking DNS configuration..."
if ! grep -q "nameserver 8.8.8.8" /etc/resolv.conf && ! grep -q "nameserver 8.8.4.4" /etc/resolv.conf; then
    echo "Configuring DNS with Google DNS servers..."
    cat > /etc/resolv.conf << DNSEOF
nameserver 8.8.8.8
nameserver 8.8.4.4
DNSEOF
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

# Install node-gyp dependencies
echo "Installing node-gyp dependencies..."
NODE_GYP_DEPS="build-essential python3 make g++"
for package in $NODE_GYP_DEPS; do
    if ! dpkg -l | grep -q "^ii  $package "; then
        apt-get install -y "$package"
    else
        echo "$package is already installed. Skipping..."
    fi
done

echo "System package installation complete!"
EOF

# Make the sudo script executable
chmod +x setup-wsl-sudo.sh

# Run the sudo portion first
echo "Running system package installation..."
sudo ./setup-wsl-sudo.sh

# Now handle NVM installation as the current user
echo "Installing NVM and Node.js..."
if [ ! -d "$HOME/.nvm" ]; then
    # Install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    
    # Load NVM immediately
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install Node.js
    nvm install 22
    nvm alias default 22
    
    # Install node-gyp globally
    npm install -g node-gyp
else
    echo "NVM is already installed. Skipping..."
fi

# Clean up the sudo script
rm setup-wsl-sudo.sh

echo "Setup complete! Please run these commands to start using Node.js:"
echo "    export NVM_DIR=\"\$HOME/.nvm\""
echo "    [ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\""
echo "Or simply close and reopen your terminal."