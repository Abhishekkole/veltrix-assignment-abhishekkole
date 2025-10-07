#!/bin/bash

echo "[Swap Optimizer Setup] Starting setup..."

# Detect OS and install Node.js if missing
OS="$(uname -s)"

detect_and_install_node() {
    if command -v node &>/dev/null && command -v npm &>/dev/null; then
        echo "[INFO] Node.js already installed: $(node -v)"
        echo "[INFO] npm version: $(npm -v)"
        return
    fi

    echo "[INFO] Node.js or npm not found. Attempting installation..."

    case "$OS" in
        Linux*)
            if [ -f /etc/debian_version ]; then
                echo "[INFO] Installing Node.js via apt..."
                curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
                sudo apt install -y nodejs
            elif [ -f /etc/redhat-release ]; then
                echo "[INFO] Installing Node.js via yum..."
                curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
                sudo yum install -y nodejs
            else
                echo "[WARN] Unsupported Linux distro. Please install Node.js manually."
                exit 1
            fi
            ;;
        Darwin*)
            if command -v brew &>/dev/null; then
                echo "[INFO] Installing Node.js via Homebrew..."
                brew install node
            else
                echo "[ERROR] Homebrew not found.Install Node.js from official website of Node.js."
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
                # in lieu of restarting the shell
                \. "$HOME/.nvm/nvm.sh"
                # Download and install Node.js:
                nvm install 22
                # Verify the Node.js version:
                node -v # Should print "v22.20.0".
                # Verify npm version:
                npm -v # Should print "10.9.3".
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "[INFO] Detected Windows (Git Bash or WSL). Please install Node.js manually from https://nodejs.org/"
            exit 1
            ;;
        *)
            echo "[ERROR] Unknown OS: $OS"
            exit 1
            ;;
    esac
}

node_version_check() {
    node_version=$(node -v | sed 's/v//' | cut -d. -f1)
    if [ $node_version -ge 18 ]; then
        echo "Node version is greater than 18"
    else
        echo "Current Node version is $node_version"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        # in lieu of restarting the shell
        \. "$HOME/.nvm/nvm.sh"
        # Download and install Node.js:
        nvm install 22
        # Verify the Node.js version:
        node -v # Should print "v22.20.0".
        # Verify npm version:
        npm -v # Should print "10.9.3".
    fi
}
detect_and_install_node
node_version_check

# Prepare logs directory
mkdir -p logs

node app.js >> "logs/setup_$(date).log"

# Install dependencies
echo "[INFO] Installing Node.js dependencies..."
npm install

# Prepare .env file
if [ ! -f .env ]; then
    if [ -f .env_example ]; then
        cp .env_example .env
        echo "[INFO] Copied .env_example to .env"
        echo "[WARN] Update your INFURA_URL in .env before proceeding."
    else
        echo "[ERROR] No .env or .env_example found. Cannot continue."
        exit 1
    fi
fi

echo "[Swap Optimizer Setup] Setup complete."
npm run dev
