#!/usr/bin/env bash

# Source sdkman if available
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# If all dependencies are available, just return
if command -v java &> /dev/null && command -v hyperfine &> /dev/null; then
    return 0 2>/dev/null || exit 0
fi

set -e

echo "Setting up Java development environment..."

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

# Install sdkman if not present
if [ ! -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
    echo "SDKMAN not found. Installing..."

    # Install dependencies
    case $PKG_MGR in
        brew)
            # On macOS, ensure we have curl and zip
            if ! command -v curl &> /dev/null; then
                install_package "curl"
            fi
            if ! command -v zip &> /dev/null; then
                install_package "zip"
            fi
            ;;
        apt)
            sudo apt update
            sudo apt install -y curl zip unzip
            ;;
        pacman)
            sudo pacman -Sy --noconfirm curl zip unzip
            ;;
    esac

    # Install SDKMAN
    curl -s "https://get.sdkman.io" | bash

    # Source sdkman for current session
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    echo "SDKMAN installed successfully"
else
    echo "SDKMAN is already installed"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Update SDKMAN
sdk update

# Install Java (default to Oracle Java 25.0.1, same as set-java-version.sh)
SDK_JAVA_VERSION_ID=${1:-25.0.1-oracle}
if ! sdk list java | grep -q "installed.*${SDK_JAVA_VERSION_ID}"; then
    echo "Installing Java ${SDK_JAVA_VERSION_ID}..."
    sdk install java "${SDK_JAVA_VERSION_ID}"
else
    echo "Java ${SDK_JAVA_VERSION_ID} is already installed"
fi

# Set Java version
sdk use java "${SDK_JAVA_VERSION_ID}"

# Install hyperfine if not present
if ! command -v hyperfine &> /dev/null; then
    install_package "hyperfine"
else
    echo "hyperfine is already installed"
fi

echo ""
echo "Setup complete! Installed tools:"
echo "Java: $(java -version 2>&1 | head -n1)"
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "You can now run:"
echo "  ./benchmark.sh  # Build and run benchmarks"
echo ""
echo "To use a different Java version, run:"
echo "  ./setup.sh <version-id>"
echo "  Example: ./setup.sh 21.0.1-graal"