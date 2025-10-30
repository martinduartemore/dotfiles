#!/usr/bin/env bash
set -o errexit
set -o nounset

script_dir() { printf "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; }
dotfiles_dir="$(script_dir)"

OS="$(uname -s)"
if [[ "${OS}" == "Darwin" ]]; then
	# macOS: prefer Brewfile if present
	if ! command -v brew >/dev/null 2>&1; then
		echo "Homebrew not found. Please run ./install.sh to bootstrap Homebrew or install it manually: https://brew.sh"
		exit 1
	fi

	if [[ -f "${dotfiles_dir}/packages/Brewfile" ]]; then
		echo "Installing macOS packages from Brewfile..."
		brew bundle --file="${dotfiles_dir}/packages/Brewfile"
	elif [[ -f "${dotfiles_dir}/packages/packages.mac.txt" ]]; then
		echo "Installing macOS packages from packages/packages.mac.txt..."
		xargs brew install < "${dotfiles_dir}/packages/packages.mac.txt" || true
	else
		echo "No packages/Brewfile or packages/packages.mac.txt found; nothing to install via brew."
	fi

else
	# Linux: detect package manager (apt or pacman)
	if command -v apt-get >/dev/null 2>&1; then
		PKG_FILE="${dotfiles_dir}/packages/packages.linux.txt"
		if [[ -f "${dotfiles_dir}/packages.txt" ]]; then
			PKG_FILE="${dotfiles_dir}/packages.txt"
		fi

		if [[ -f "${PKG_FILE}" ]]; then
			echo "Updating apt and installing packages from ${PKG_FILE}..."
			sudo apt-get update
			xargs --arg-file "${PKG_FILE}" sudo apt-get install -y
		else
			echo "No package list found for apt (packages.txt or packages/packages.linux.txt)."
			exit 1
		fi

	elif command -v pacman >/dev/null 2>&1; then
		PKG_FILE="${dotfiles_dir}/packages/packages.linux.txt"
		if [[ -f "${dotfiles_dir}/packages.txt" ]]; then
			PKG_FILE="${dotfiles_dir}/packages.txt"
		fi

		if [[ -f "${PKG_FILE}" ]]; then
			echo "Installing packages with pacman from ${PKG_FILE}..."
			sudo pacman -Sy --noconfirm $(tr '\n' ' ' < "${PKG_FILE}")
		else
			echo "No package list found for pacman (packages.txt or packages/packages.linux.txt)."
			exit 1
		fi

	else
		echo "Unsupported Linux package manager (no apt-get or pacman found)."
		exit 1
	fi
fi

