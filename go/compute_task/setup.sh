#!/usr/bin/env bash

set -e

echo "Setting up Go development environment..."

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

# Install or update Go
if ! command -v go &> /dev/null; then
    echo "Go not found. Installing..."
    case $PKG_MGR in
        brew)
            install_package "go"
            ;;
        apt)
            install_package "golang"
            ;;
        pacman)
            install_package "go"
            ;;
    esac
else
    echo "Go is already installed. Updating to latest version..."
    case $PKG_MGR in
        brew)
            brew upgrade go 2>/dev/null || echo "Go is already at latest version"
            ;;
        apt)
            sudo apt update && sudo apt install --only-upgrade -y golang 2>/dev/null || echo "Go is already at latest version"
            ;;
        pacman)
            sudo pacman -S --noconfirm go
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
echo "Go: $(go version)"
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "You can now run:"
echo "  ./build.sh      # Build the Go executable"
echo "  ./benchmark.sh  # Run benchmarks"