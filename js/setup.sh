#!/usr/bin/env bash

# Source asdf if available
if command -v brew &> /dev/null && [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
    . "$(brew --prefix asdf)/libexec/asdf.sh"
fi

# If all runtimes are available, just return
if command -v node &> /dev/null && command -v bun &> /dev/null && command -v deno &> /dev/null; then
    return 0 2>/dev/null || exit 0
fi

set -e

echo "Setting up JavaScript runtimes..."

# Check if asdf is installed
if ! command -v asdf &> /dev/null; then
    echo "asdf not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "Error: Homebrew is required but not installed."
        echo "Install it from: https://brew.sh"
        exit 1
    fi
    brew install asdf

    # Add asdf to shell
    ASDF_DIR="$(brew --prefix asdf)"
    if [ -f ~/.zshrc ]; then
        if ! grep -q "asdf.sh" ~/.zshrc; then
            echo -e "\n. ${ASDF_DIR}/libexec/asdf.sh" >> ~/.zshrc
            echo "Added asdf to ~/.zshrc"
        fi
    elif [ -f ~/.bashrc ]; then
        if ! grep -q "asdf.sh" ~/.bashrc; then
            echo -e "\n. ${ASDF_DIR}/libexec/asdf.sh" >> ~/.bashrc
            echo "Added asdf to ~/.bashrc"
        fi
    fi

    # Source asdf for current session
    . "${ASDF_DIR}/libexec/asdf.sh"
    echo "asdf installed successfully"
else
    echo "asdf is already installed"
    # Ensure asdf is sourced in current session
    if [ -z "$ASDF_DIR" ]; then
        if command -v brew &> /dev/null; then
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

echo ""
echo "Setup complete! Installed runtimes:"
echo "Node: $(node --version 2>/dev/null || echo 'not in PATH - restart shell')"
echo "Bun: $(bun --version 2>/dev/null || echo 'not in PATH - restart shell')"
echo "Deno: $(deno --version 2>/dev/null | head -n1 || echo 'not in PATH - restart shell')"
echo ""
echo "If versions show 'not in PATH', please restart your shell or run:"
echo "  source ~/.zshrc  # or ~/.bashrc"
