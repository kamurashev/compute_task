#!/usr/bin/env bash

# Source cargo env if available
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# If all dependencies are available, just return
if command -v cargo &> /dev/null && command -v rustc &> /dev/null && command -v hyperfine &> /dev/null; then
    return 0 2>/dev/null || exit 0
fi

set -e

echo "Setting up Rust development environment..."

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

# Install Rust if not present
if ! command -v cargo &> /dev/null || ! command -v rustc &> /dev/null; then
    echo "Rust not found. Installing via rustup..."

    # Install dependencies for rustup
    case $PKG_MGR in
        apt)
            sudo apt update
            sudo apt install -y curl build-essential
            ;;
        pacman)
            sudo pacman -Sy --noconfirm curl base-devel
            ;;
    esac

    # Install rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Source cargo env for current session
    source "$HOME/.cargo/env"

    echo "Rust installed successfully"
else
    echo "Rust is already installed"
fi

# Install hyperfine if not present
if ! command -v hyperfine &> /dev/null; then
    install_package "hyperfine"
else
    echo "hyperfine is already installed"
fi

echo ""
echo "Setup complete! Installed tools:"
echo "Rust: $(rustc --version)"
echo "Cargo: $(cargo --version)"
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "You can now run:"
echo "  ./build.sh      # Build the Rust executable"
echo "  ./benchmark.sh  # Run benchmarks"