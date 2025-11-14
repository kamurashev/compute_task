#!/usr/bin/env bash

set -e

echo "Setting up V development environment..."

# Detect package manager
if command -v brew &> /dev/null; then
    PKG_MGR="brew"
elif command -v apt &> /dev/null; then
    PKG_MGR="apt"
elif command -v pacman &> /dev/null; then
    PKG_MGR="pacman"
else
    echo "Error: No supported package manager found (brew, apt, or pacman)"
    exit 1
fi

echo "Detected package manager: $PKG_MGR"

# Function to install package
install_package() {
    local pkg=$1
    echo "Installing $pkg..."

    case $PKG_MGR in
        brew)
            brew install "$pkg"
            ;;
        apt)
            sudo apt update && sudo apt install -y "$pkg"
            ;;
        pacman)
            sudo pacman -Sy --noconfirm "$pkg"
            ;;
    esac
}

# Install or update V
if ! command -v v &> /dev/null; then
    echo "V not found. Installing..."

    case $PKG_MGR in
        brew)
            install_package "vlang"
            ;;
        apt)
            # Install dependencies
            sudo apt update
            sudo apt install -y git make gcc

            # Clone and build V
            if [ ! -d "$HOME/.vlang" ]; then
                git clone https://github.com/vlang/v "$HOME/.vlang"
                cd "$HOME/.vlang"
                make
                sudo ./v symlink
            fi
            ;;
        pacman)
            # Install dependencies
            sudo pacman -Sy --noconfirm git make gcc

            # Clone and build V from source
            if [ ! -d "$HOME/.vlang" ]; then
                git clone https://github.com/vlang/v "$HOME/.vlang"
                cd "$HOME/.vlang"
                make
                sudo ./v symlink
            fi
            ;;
    esac

    echo "V installed successfully"
else
    echo "V is already installed. Updating to latest version..."

    case $PKG_MGR in
        brew)
            brew upgrade vlang 2>/dev/null || echo "V is already at latest version"
            ;;
        apt|pacman)
            # Update V from source
            if [ -d "$HOME/.vlang" ]; then
                cd "$HOME/.vlang"
                git pull
                make
                echo "V updated successfully"
            else
                echo "V installation directory not found, cannot update"
            fi
            ;;
    esac
fi

# Install or update hyperfine
if ! command -v hyperfine &> /dev/null; then
    install_package "hyperfine"
else
    echo "hyperfine is already installed. Checking for updates..."
    case $PKG_MGR in
        brew)
            brew upgrade hyperfine 2>/dev/null || echo "hyperfine is already at latest version"
            ;;
        apt)
            sudo apt update && sudo apt install --only-upgrade -y hyperfine 2>/dev/null || echo "hyperfine is already at latest version"
            ;;
        pacman)
            sudo pacman -S --noconfirm hyperfine
            ;;
    esac
fi

echo ""
echo "Setup complete! Installed tools:"
echo "V: $(v version)"
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "You can now run:"
echo "  ./build.sh      # Build the V executable"
echo "  ./benchmark.sh  # Run benchmarks"