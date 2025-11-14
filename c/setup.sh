#!/usr/bin/env bash

# If all dependencies are available, just return
if command -v clang &> /dev/null && command -v hyperfine &> /dev/null; then
    # Check if libomp is available (macOS specific check)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [ -d "/opt/homebrew/opt/libomp" ] || [ -d "/usr/local/opt/libomp" ]; then
            return 0 2>/dev/null || exit 0
        fi
    else
        return 0 2>/dev/null || exit 0
    fi
fi

set -e

echo "Setting up C development environment..."

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

# Install clang if not present
if ! command -v clang &> /dev/null; then
    case $PKG_MGR in
        brew)
            install_package "llvm"
            ;;
        apt)
            install_package "clang"
            ;;
        pacman)
            install_package "clang"
            ;;
    esac
else
    echo "clang is already installed"
fi

# Install OpenMP support
case $PKG_MGR in
    brew)
        if ! brew list libomp &> /dev/null; then
            install_package "libomp"
        else
            echo "libomp is already installed"
        fi
        ;;
    apt)
        if ! dpkg -l | grep -q libomp-dev; then
            install_package "libomp-dev"
        else
            echo "libomp-dev is already installed"
        fi
        ;;
    pacman)
        if ! pacman -Q openmp &> /dev/null 2>&1; then
            install_package "openmp"
        else
            echo "openmp is already installed"
        fi
        ;;
esac

# Install hyperfine if not present
if ! command -v hyperfine &> /dev/null; then
    install_package "hyperfine"
else
    echo "hyperfine is already installed"
fi

echo ""
echo "Setup complete! Installed tools:"
echo "Clang: $(clang --version | head -n1)"
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "You can now run:"
echo "  ./build.sh      # Build the C executable"
echo "  ./benchmark.sh  # Run benchmarks"