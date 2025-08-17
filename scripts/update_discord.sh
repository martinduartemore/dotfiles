#!/bin/bash

# Enable strict mode to handle errors better
set -euo pipefail
IFS=$'\n\t'

# Variables
DISCORD_URL="https://discord.com/api/download?platform=linux&format=deb"
TEMP_DIR="/tmp"
RANDOM_SUFFIX=$(date +%s%N | sha256sum | base64 | head -c 8)
PACKAGE_NAME="discord-${RANDOM_SUFFIX}.deb"

# Download the latest Discord .deb package to the /tmp directory with a random suffix
DOWNLOADED_FILE="${TEMP_DIR}/${PACKAGE_NAME}"
echo "Downloading Discord package..."
wget -O "${DOWNLOADED_FILE}" "${DISCORD_URL}"

# Ensure the file was successfully downloaded
if [[ ! -f "${DOWNLOADED_FILE}" ]]; then
  echo "Download failed or file not found."
  exit 1
fi

# Get the package details
PACKAGE_INFO=$(dpkg-deb --info "${DOWNLOADED_FILE}")
PACKAGE_VERSION=$(echo "${PACKAGE_INFO}" | grep Version | awk '{print $2}')

# Inform the user about the downloaded version
echo "Downloaded Discord version: ${PACKAGE_VERSION}"

# Install the downloaded package
echo "Installing Discord package..."
sudo apt install -y "${DOWNLOADED_FILE}"

# Clean up
echo "Cleaning up..."
rm -f "${DOWNLOADED_FILE}"

echo "Discord has been successfully updated to version ${PACKAGE_VERSION}."
