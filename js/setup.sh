#!/usr/bin/env bash

# Source asdf if available
if [ -f "$HOME/.asdf/asdf.sh" ]; then
    . "$HOME/.asdf/asdf.sh"
elif command -v brew &> /dev/null && [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
    . "$(brew --prefix asdf)/libexec/asdf.sh"
fi

# If all runtimes are available, just return
if command -v node &> /dev/null && command -v bun &> /dev/null && command -v deno &> /dev/null && command -v hyperfine &> /dev/null; then
    return 0 2>/dev/null || exit 0
fi

set -e

echo "Setting up JavaScript development environment..."

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

# Check if asdf is installed
if ! command -v asdf &> /dev/null; then
    echo "asdf not found. Installing..."

    case $PKG_MGR in
        brew)
            install_package "asdf"

            # Add asdf to shell
            ASDF_DIR="$(brew --prefix asdf)"
            SHELL_CONFIG=""
            if [ -f ~/.zshrc ]; then
                SHELL_CONFIG="$HOME/.zshrc"
                if ! grep -q "asdf.sh" "$SHELL_CONFIG"; then
                    echo '' >> "$SHELL_CONFIG"
                    echo ". ${ASDF_DIR}/libexec/asdf.sh" >> "$SHELL_CONFIG"
                    echo "Added asdf to $SHELL_CONFIG"
                fi
            elif [ -f ~/.bashrc ]; then
                SHELL_CONFIG="$HOME/.bashrc"
                if ! grep -q "asdf.sh" "$SHELL_CONFIG"; then
                    echo '' >> "$SHELL_CONFIG"
                    echo ". ${ASDF_DIR}/libexec/asdf.sh" >> "$SHELL_CONFIG"
                    echo "Added asdf to $SHELL_CONFIG"
                fi
            fi

            # Source asdf for current session
            . "${ASDF_DIR}/libexec/asdf.sh"
            ;;

        apt)
            # Install dependencies
            sudo apt update
            sudo apt install -y curl git

            # Install asdf via git
            if [ ! -d "$HOME/.asdf" ]; then
                git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.0
            fi

            # Add to shell config
            SHELL_CONFIG=""
            if [ -f "$HOME/.zshrc" ]; then
                SHELL_CONFIG="$HOME/.zshrc"
            elif [ -f "$HOME/.bashrc" ]; then
                SHELL_CONFIG="$HOME/.bashrc"
            fi

            if [ -n "$SHELL_CONFIG" ] && ! grep -q "asdf.sh" "$SHELL_CONFIG"; then
                echo '' >> "$SHELL_CONFIG"
                echo '. "$HOME/.asdf/asdf.sh"' >> "$SHELL_CONFIG"
                echo "Added asdf to $SHELL_CONFIG"
            fi

            # Source asdf for current session
            . "$HOME/.asdf/asdf.sh"
            ;;

        pacman)
            # Install asdf via AUR or git
            if command -v yay &> /dev/null; then
                yay -S --noconfirm asdf-vm
            else
                # Install dependencies
                sudo pacman -Sy --noconfirm curl git

                # Install asdf via git
                if [ ! -d "$HOME/.asdf" ]; then
                    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.0
                fi
            fi

            # Add to shell config
            SHELL_CONFIG=""
            if [ -f "$HOME/.zshrc" ]; then
                SHELL_CONFIG="$HOME/.zshrc"
            elif [ -f "$HOME/.bashrc" ]; then
                SHELL_CONFIG="$HOME/.bashrc"
            fi

            if [ -n "$SHELL_CONFIG" ] && ! grep -q "asdf.sh" "$SHELL_CONFIG"; then
                echo '' >> "$SHELL_CONFIG"
                echo '. "$HOME/.asdf/asdf.sh"' >> "$SHELL_CONFIG"
                echo "Added asdf to $SHELL_CONFIG"
            fi

            # Source asdf for current session
            . "$HOME/.asdf/asdf.sh"
            ;;
    esac

    echo "asdf installed successfully"
else
    echo "asdf is already installed"
    # Ensure asdf is sourced in current session
    if ! command -v asdf &> /dev/null; then
        if [ -f "$HOME/.asdf/asdf.sh" ]; then
            . "$HOME/.asdf/asdf.sh"
        elif command -v brew &> /dev/null && [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
            . "$(brew --prefix asdf)/libexec/asdf.sh"
        fi
    fi
fi

# Function to install runtime if not present
install_runtime() {
    local runtime=$1
    local version=$2

    # Check if plugin is installed
    if ! asdf plugin list | grep -q "^${runtime}$"; then
        echo "Adding ${runtime} plugin..."
        asdf plugin add "${runtime}"
    fi

    # Check if version is installed
    if ! asdf list "${runtime}" 2>/dev/null | grep -q "${version}"; then
        echo "Installing ${runtime} ${version}..."
        asdf install "${runtime}" "${version}"
    else
        echo "${runtime} ${version} is already installed"
    fi

    # Set global version
    asdf set -u "${runtime}" "${version}" 2>/dev/null || asdf global "${runtime}" "${version}" 2>/dev/null
    asdf reshim "${runtime}"
}

# Install Node.js
install_runtime "nodejs" "latest"

# Install Bun
install_runtime "bun" "latest"

# Install Deno
install_runtime "deno" "latest"

# Install hyperfine if not present
if ! command -v hyperfine &> /dev/null; then
    install_package "hyperfine"
else
    echo "hyperfine is already installed"
fi

echo ""
echo "Setup complete! Installed runtimes:"
echo "Node.js: $(node --version 2>/dev/null || echo 'not in PATH - restart shell')"
echo "Bun: $(bun --version 2>/dev/null || echo 'not in PATH - restart shell')"
echo "Deno: $(deno --version 2>/dev/null | head -n1 || echo 'not in PATH - restart shell')"
echo "Hyperfine: $(hyperfine --version)"
echo ""
echo "If versions show 'not in PATH', please restart your shell or run:"
echo "  source ~/.zshrc  # or ~/.bashrc"
echo ""
echo "You can now run:"
echo "  ./benchmark.sh  # Run benchmarks"
