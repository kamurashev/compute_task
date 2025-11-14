#!/usr/bin/env bash

# If all dependencies are available, just return
if command -v zig &> /dev/null && command -v hyperfine &> /dev/null; then
    return 0 2>/dev/null || exit 0
fi

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

# Install Zig if not present
if ! command -v zig &> /dev/null; then
    install_package "zig"
else
    echo "Zig is already installed"
fi

# Install hyperfine if not present
if ! command -v hyperfine &> /dev/null; then
    install_package "hyperfine"
else
    echo "hyperfine is already installed"
fi

echo ""
echo "Setup complete! Installed tools:"
echo "Zig: $(zig version)"
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "You can now run:"
echo "  ./build.sh      # Build the Zig executable"
echo "  ./benchmark.sh  # Run benchmarks"