#!/bin/bash

# Default repos directory
REPOS_DIR="$HOME/repos"

# Help message
show_help() {
    echo "Usage: $0 [OPTIONS] repository_url [repository_name]"
    echo
    echo "Options:"
    echo "  -h, --help                Show this help message"
    echo "  -d, --directory DIR       Set custom directory for repositories (default: ~/repos)"
    echo "  -l, --list               List all cloned repositories and their status"
    echo "  -u, --update             Update all existing repositories"
    echo
    echo "Examples:"
    echo "  $0 https://github.com/user/repo.git"
    echo "  $0 https://github.com/user/repo.git custom-name"
    echo "  $0 -d ~/custom/path https://github.com/user/repo.git"
    echo "  $0 -l"
    echo "  $0 -u"
}

# Function to clone or pull repository
clone_or_pull_repo() {
    local url=$1
    local name=$2
    
    # If no name provided, extract from URL
    if [ -z "$name" ]; then
        name=$(basename "$url" .git)
    fi
    
    if [ -d "$REPOS_DIR/$name" ]; then
        echo "Repository $name already exists. Updating..."
        cd "$REPOS_DIR/$name" || return
        git pull
        cd ..
    else
        echo "Cloning repository $name..."
        git clone "$url" "$name"
    fi
}

# Function to list repositories
list_repos() {
    if [ ! -d "$REPOS_DIR" ]; then
        echo "No repositories directory found at $REPOS_DIR"
        return
    fi

    echo "Repositories in $REPOS_DIR:"
    echo "------------------------"
    
    for repo in "$REPOS_DIR"/*/; do
        if [ -d "$repo/.git" ]; then
            repo_name=$(basename "$repo")
            echo -e "\n$repo_name:"
            cd "$repo" || continue
            echo "Current branch: $(git branch --show-current)"
            echo "Status:"
            git status -s
            cd - > /dev/null || exit
        fi
    done
}

# Function to update all repositories
update_repos() {
    if [ ! -d "$REPOS_DIR" ]; then
        echo "No repositories directory found at $REPOS_DIR"
        return
    }

    echo "Updating all repositories in $REPOS_DIR"
    echo "------------------------"
    
    for repo in "$REPOS_DIR"/*/; do
        if [ -d "$repo/.git" ]; then
            repo_name=$(basename "$repo")
            echo -e "\nUpdating $repo_name..."
            cd "$repo" || continue
            git pull
            cd - > /dev/null || exit
        fi
    done
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--directory)
            REPOS_DIR="$2"
            shift 2
            ;;
        -l|--list)
            list_repos
            exit 0
            ;;
        -u|--update)
            update_repos
            exit 0
            ;;
        *)
            break
            ;;
    esac
done

# Create repos directory if it doesn't exist
mkdir -p "$REPOS_DIR"
cd "$REPOS_DIR" || exit 1

# Handle repository cloning
if [ $# -gt 0 ]; then
    clone_or_pull_repo "$1" "$2"
else
    if [ "$1" != "-l" ] && [ "$1" != "-u" ]; then
        show_help
    fi
fi
