# WSL Development Environment Setup Documentation

This documentation covers two scripts designed to streamline the setup of a WSL development environment and manage Git repositories:
1. `setup-wsl.sh` - Environment setup script
2. `clone-repos.sh` - Repository management script

## Table of Contents
- [Environment Setup Script](#environment-setup-script)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Features](#features)
  - [Troubleshooting](#troubleshooting)
- [Repository Management Script](#repository-management-script)
  - [Usage](#usage)
  - [Commands](#commands)
  - [Examples](#examples)
- [Best Practices](#best-practices)
- [FAQ](#faq)

## Environment Setup Script

### Prerequisites

Before running the setup script, ensure you have:
- Windows 10 version 2004 or higher
- WSL2 installed and configured
   - `wsl --install`
   - restart
   - once in wsl lets run bash script (use mount for c drive)
   ```
   cd $HOME
   mkdir repos
   git clone <git repo url>
   cd repos/sample-repo
   ```
- Administrator privileges
- Ubuntu or Debian-based WSL distribution

### Installation

1. Save the script as `setup-wsl.sh`
2. Make it executable:
   ```bash
   chmod +x setup-wsl.sh
   ```
3. Run with sudo:
   ```bash
   sudo ./setup-wsl.sh
   ```

### Features

The setup script installs and configures:

1. **DNS Configuration**
   - Configures Google DNS servers (8.8.8.8 and 8.8.4.4)
   - Prevents duplicate configurations
   - Resolves common WSL DNS issues

2. **Java Development Environment**
   - OpenJDK 11
   - JAVA_HOME environment variable configuration
   - Automatic path setup

3. **Node.js Environment**
   - Node Version Manager (nvm)
   - Node.js 22 (default)
   - Automatic bashrc configuration
   - Global npm configuration

4. **Cypress Dependencies**
   - GTK dependencies
   - System libraries
   - Audio and visual components

5. **Node-gyp Setup**
   - Build essentials
   - Python3
   - Make and G++ compilers

### Troubleshooting

Common issues and solutions:

1. **DNS Issues**
   - Check `/etc/resolv.conf` contents
   - Verify network connectivity
   - Try restarting WSL

2. **Java Installation**
   - Verify JAVA_HOME path
   - Check Java version: `java -version`
   - Ensure profile is sourced

3. **Node.js Issues**
   - Verify NVM installation: `nvm --version`
   - Check Node version: `node --version`
   - Source bashrc if needed: `source ~/.bashrc`

## Repository Management Script

### Usage

Basic syntax:
```bash
./clone-repos.sh [OPTIONS] repository_url [repository_name]
```

### Commands

1. **Clone Repository**
   ```bash
   ./clone-repos.sh https://github.com/user/repo.git
   ```

2. **Clone with Custom Name**
   ```bash
   ./clone-repos.sh https://github.com/user/repo.git custom-name
   ```

3. **Use Custom Directory**
   ```bash
   ./clone-repos.sh -d ~/custom/path https://github.com/user/repo.git
   ```

4. **List Repositories**
   ```bash
   ./clone-repos.sh -l
   ```

5. **Update All Repositories**
   ```bash
   ./clone-repos.sh -u
   ```

### Options

| Option | Long Form | Description |
|--------|-----------|-------------|
| -h | --help | Show help message |
| -d | --directory | Set custom directory |
| -l | --list | List all repositories |
| -u | --update | Update all repositories |

### Examples

1. **Basic Repository Clone**
   ```bash
   ./clone-repos.sh https://github.com/user/repo.git
   ```
   Creates: `~/repos/repo`

2. **Custom Named Clone**
   ```bash
   ./clone-repos.sh https://github.com/user/repo.git my-project
   ```
   Creates: `~/repos/my-project`

3. **Custom Directory Clone**
   ```bash
   ./clone-repos.sh -d ~/projects https://github.com/user/repo.git
   ```
   Creates: `~/projects/repo`

## Best Practices

1. **Environment Setup**
   - Run setup script once after WSL installation
   - Restart terminal after setup
   - Keep sudo usage to minimum

2. **Repository Management**
   - Use meaningful repository names
   - Maintain organized directory structure
   - Regular repository updates

## FAQ

**Q: Do I need to run setup-wsl.sh more than once?**
A: No, the script is idempotent and only needs to be run once. It will skip already installed components.

**Q: Can I update individual repositories?**
A: Yes, simply run clone-repos.sh with the repository URL again. It will detect the existing repository and update it.

**Q: Where are repositories stored by default?**
A: By default, repositories are stored in `~/repos/` in your WSL environment.

**Q: How do I switch Node.js versions?**
A: Use NVM commands:
```bash
nvm install <version>
nvm use <version>
```

**Q: Can I modify DNS settings after initial setup?**
A: Yes, manually edit `/etc/resolv.conf` or run the setup script again.

## Support

For issues or feature requests:
1. Check the troubleshooting section
2. Verify prerequisites
3. Check system compatibility
4. Contact your system administrator

## Updates and Maintenance

- Scripts are maintained to be idempotent
- Regular updates recommended
- Check for new versions periodically
- Backup configurations before updates

Remember to regularly update your WSL environment and keep repositories in sync with remote sources.
