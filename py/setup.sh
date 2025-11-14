#!/usr/bin/env bash

# Source pyenv if available
if [ -f "$HOME/.pyenv/bin/pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# If all dependencies are available, just return
if command -v pyenv &> /dev/null && command -v hyperfine &> /dev/null; then
    # Check if required Python versions are installed
    if pyenv versions --bare | grep -q "3.13.3" && \
       pyenv versions --bare | grep -q "3.15-dev" && \
       pyenv versions --bare | grep -q "pypy3.11-7.3.19"; then
        return 0 2>/dev/null || exit 0
    fi
fi

set -e

echo "Setting up Python development environment..."

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

# Install pyenv if not present
if ! command -v pyenv &> /dev/null; then
    echo "pyenv not found. Installing..."

    case $PKG_MGR in
        brew)
            install_package "pyenv"
            ;;
        apt)
            # Install dependencies for building Python
            sudo apt update
            sudo apt install -y make build-essential libssl-dev zlib1g-dev \
                libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
                libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
                libffi-dev liblzma-dev

            # Install pyenv via git
            if [ ! -d "$HOME/.pyenv" ]; then
                curl https://pyenv.run | bash
            fi
            ;;
        pacman)
            # Install dependencies for building Python
            sudo pacman -Sy --noconfirm base-devel openssl zlib xz tk

            # Install pyenv via git
            if [ ! -d "$HOME/.pyenv" ]; then
                curl https://pyenv.run | bash
            fi
            ;;
    esac

    # Setup pyenv in PATH for current session
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

    # Add pyenv to shell config
    SHELL_CONFIG=""
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    fi

    if [ -n "$SHELL_CONFIG" ] && ! grep -q "PYENV_ROOT" "$SHELL_CONFIG"; then
        echo '' >> "$SHELL_CONFIG"
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$SHELL_CONFIG"
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$SHELL_CONFIG"
        echo 'eval "$(pyenv init -)"' >> "$SHELL_CONFIG"
        echo "Added pyenv to $SHELL_CONFIG"
    fi

    echo "pyenv installed successfully"
else
    echo "pyenv is already installed"
fi

# Function to install Python version if not present
install_python_version() {
    local version=$1

    if ! pyenv versions --bare | grep -q "^${version}$"; then
        echo "Installing Python ${version}..."
        pyenv install "${version}"
    else
        echo "Python ${version} is already installed"
    fi
}

# Install Python versions
install_python_version "3.13.3"
install_python_version "3.15-dev"
install_python_version "pypy3.11-7.3.19"

# Set local Python versions for this directory
pyenv local 3.13.3 3.15-dev pypy3.11-7.3.19

# Install hyperfine if not present
if ! command -v hyperfine &> /dev/null; then
    install_package "hyperfine"
else
    echo "hyperfine is already installed"
fi

echo ""
echo "Setup complete! Installed Python versions:"
pyenv versions
echo ""
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "You can now run:"
echo "  ./benchmark.sh  # Run benchmarks"