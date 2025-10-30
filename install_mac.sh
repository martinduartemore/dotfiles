#!/usr/bin/env bash
set -o errexit
set -o nounset

# macOS-specific installer helpers. This file is sourced by install.sh and
# relies on utility functions (print_*, symlink_file) defined there. To make
# this script runnable standalone we source the shared utils if necessary.

_maybe_source_utils() {
    if ! declare -F print_header >/dev/null 2>&1; then
        # shellcheck source=/dev/null
        source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install_utils.sh"
    fi
}

ensure_xcode_cli() {
    if ! xcode-select -p >/dev/null 2>&1; then
        print_info "Xcode command line tools not found. Installing...\n"
        # This will prompt the user; if it fails, ask them to run it manually.
        xcode-select --install || true
        print_info "If the installer above did not start, please run: xcode-select --install\n"
        # Wait for the tools to be installed (best-effort)
        until xcode-select -p >/dev/null 2>&1; do
            print_info "Waiting for Xcode CLI to finish installing...\n"
            sleep 5
        done
    else
        print_info "Xcode CLI already installed.\n"
    fi
}

ensure_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        print_info "Homebrew not found. Installing Homebrew...\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_info "Homebrew installed. Make sure your shell's PATH includes Homebrew (see installer output).\n"
    else
        print_info "Homebrew present; updating...\n"
        brew update || true
    fi
}

install_brewfile() {
    # use shared dotfiles_dir if provided by the caller (install.sh); otherwise
    # fall back to the script location
    local df
    df="${dotfiles_dir:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

    if [[ -f "${df}/packages/Brewfile" ]]; then
        print_info "Installing packages from Brewfile...\n"
        brew bundle --file="${df}/packages/Brewfile" || true
    else
        print_info "No Brewfile found at ${df}/packages/Brewfile. Skipping brew bundle.\n"
    fi
}

install_local_fonts() {
    local df fonts_dir dest
    df="${dotfiles_dir:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    fonts_dir="${df}/local/share/fonts"
    dest="${HOME}/Library/Fonts"

    if [[ -d "${fonts_dir}" ]]; then
        print_info "Copying local fonts to ${dest}...\n"
        mkdir -p "${dest}"
        # copy but don't fail the script if some files already exist
        cp -R "${fonts_dir}/." "${dest}/" || true
    else
        print_info "No local fonts directory found at ${fonts_dir}.\n"
    fi
}

main_mac() {
    _maybe_source_utils
    print_header "Running macOS installer...\n"

    # Ensure dotfiles_dir is available to symlink_file; prefer caller-provided
    # `dotfiles_dir` but fall back to the script location when run standalone.
    local df
    df="${dotfiles_dir:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    if [[ -z "${dotfiles_dir:-}" ]]; then
        dotfiles_dir="${df}"
    fi

    ensure_xcode_cli
    ensure_homebrew

    install_brewfile
    install_local_fonts

    print_header "Symlinking dotfiles (macOS)...\n"
    symlink_file "zshrc"
    symlink_file "bashrc"
    symlink_file "bash_profile"
    symlink_file "scripts"
    symlink_file "tmux.conf"
    symlink_file "vim"
    symlink_file "condarc"
    symlink_file "tmuxp"
    symlink_file "config/wezterm"
    symlink_file "config/nvim"

    print_success "macOS install finished.\n"
}

