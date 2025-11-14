#!/usr/bin/env bash

# If all dependencies are available, just return
if command -v go &> /dev/null && command -v hyperfine &> /dev/null; then
    return 0 2>/dev/null || exit 0
fi

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

# Install Go if not present
if ! command -v go &> /dev/null; then
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
    echo "Go is already installed"
fi

# Install hyperfine if not present
if ! command -v hyperfine &> /dev/null; then
    install_package "hyperfine"
else
    echo "hyperfine is already installed"
fi

echo ""
echo "Setup complete! Installed tools:"
echo "Go: $(go version)"
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "You can now run:"
echo "  ./build.sh      # Build the Go executable"
echo "  ./benchmark.sh  # Run benchmarks"