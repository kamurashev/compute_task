#!/usr/bin/env bash

set -e

echo "Setting up Zig development environment..."

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

# Install or update Zig
if ! command -v zig &> /dev/null; then
    echo "Zig not found. Installing..."
    install_package "zig"
else
    echo "Zig is already installed. Updating to latest version..."
    case $PKG_MGR in
        brew)
            brew upgrade zig 2>/dev/null || echo "Zig is already at latest version"
            ;;
        apt)
            sudo apt update && sudo apt install --only-upgrade -y zig 2>/dev/null || echo "Zig is already at latest version"
            ;;
        pacman)
            sudo pacman -S --noconfirm zig
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
echo "Zig: $(zig version)"
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "You can now run:"
echo "  ./build.sh      # Build the Zig executable"
echo "  ./benchmark.sh  # Run benchmarks"