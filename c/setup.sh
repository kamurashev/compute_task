#!/usr/bin/env bash

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
            # Install clang with system upgrade to avoid dependency issues
            echo "Installing Clang with system upgrade..."
            sudo apt update && sudo apt upgrade -y
            sudo apt install -y clang
            ;;
        pacman)
            # Install LLVM packages ensuring versions match
            echo "Installing LLVM, LLVM-libs, and Clang with dependencies..."
            sudo pacman -Syu --noconfirm llvm llvm-libs clang
            # Update library cache after installing
            echo "Updating library cache..."
            sudo ldconfig
            ;;
    esac
else
    echo "clang is already installed"

    # Verify clang can actually run (both apt and pacman)
    if [ "$PKG_MGR" = "apt" ] || [ "$PKG_MGR" = "pacman" ]; then
        if ! clang --version &> /dev/null; then
            echo "Clang has library issues (missing or outdated system libraries)"
            echo "This usually happens when system packages are out of sync."

            case $PKG_MGR in
                apt)
                    echo "Upgrading system and reinstalling clang..."
                    sudo apt update && sudo apt upgrade -y
                    sudo apt install -y --reinstall clang
                    ;;
                pacman)
                    echo "Upgrading system and LLVM packages..."
                    sudo pacman -Syu --noconfirm llvm llvm-libs clang
                    sudo ldconfig
                    ;;
            esac
        elif [ "$PKG_MGR" = "pacman" ]; then
            # Check for version mismatch between clang and llvm-libs (Arch specific)
            if pacman -Q clang llvm-libs &> /dev/null 2>&1; then
                CLANG_VER=$(pacman -Q clang | awk '{print $2}' | cut -d'-' -f1)
                LLVM_LIBS_VER=$(pacman -Q llvm-libs | awk '{print $2}' | cut -d'-' -f1)

                if [ "$CLANG_VER" != "$LLVM_LIBS_VER" ]; then
                    echo "Version mismatch detected:"
                    echo "  clang: $CLANG_VER"
                    echo "  llvm-libs: $LLVM_LIBS_VER"
                    echo "Upgrading system and LLVM packages to sync versions..."
                    sudo pacman -Syu --noconfirm llvm llvm-libs clang
                    sudo ldconfig
                fi
            fi
        fi
    fi
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
            # Update library cache after installing openmp
            echo "Updating library cache..."
            sudo ldconfig
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