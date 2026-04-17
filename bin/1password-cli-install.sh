#!/usr/bin/env zsh
set -euo pipefail

# Detect OS and arch
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$(uname -m)" in
  x86_64)  ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)
    echo "error: unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

# Map OS name to AgileBits naming convention
case "$OS" in
  darwin) OS_NAME="darwin" ;;
  linux)  OS_NAME="linux" ;;
  *)
    echo "error: unsupported OS: $OS" >&2
    exit 1
    ;;
esac

INSTALL_DIR="/usr/local/bin"

# Fetch latest version
echo "Checking latest version..."
OP_VERSION="v$(curl -fsSL https://app-updates.agilebits.com/check/1/0/CLI2/en/2.0.0/N \
  | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"

if [[ -z "$OP_VERSION" || "$OP_VERSION" == "v" ]]; then
  echo "error: could not determine latest version" >&2
  exit 1
fi

# Check if already installed and at what version
if command -v op &>/dev/null; then
  INSTALLED="v$(op --version 2>/dev/null)"
  if [[ "$INSTALLED" == "$OP_VERSION" ]]; then
    echo "op ${OP_VERSION} is already up to date"
    exit 0
  else
    echo "Upgrading op ${INSTALLED} -> ${OP_VERSION}"
  fi
else
  echo "Installing op ${OP_VERSION}"
fi

# Build download URL
DOWNLOAD_URL="https://cache.agilebits.com/dist/1P/op2/pkg/${OP_VERSION}/op_${OS_NAME}_${ARCH}_${OP_VERSION}.zip"

# Download, extract, clean up
TMPFILE="$(mktemp /tmp/op_XXXXXX.zip)"
trap 'rm -f "$TMPFILE"' EXIT

echo "Downloading ${DOWNLOAD_URL}..."
curl -fsSL "$DOWNLOAD_URL" -o "$TMPFILE"

echo "Installing to ${INSTALL_DIR}..."
unzip -od "$INSTALL_DIR" "$TMPFILE"

# Verify the install
INSTALLED_VERSION="$(op --version 2>/dev/null)"
echo "Done — op ${INSTALLED_VERSION} installed at $(command -v op)"