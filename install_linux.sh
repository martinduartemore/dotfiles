#!/usr/bin/env bash
set -o errexit
set -o nounset

# Linux-specific installer. Defines main_linux which is called by the top-level
# `install.sh` dispatcher. It relies on utility functions from
# `install_utils.sh` (print_*, symlink_file). We source the utils file if it's
# not already loaded to make this script runnable standalone.

_maybe_source_utils() {
    if ! declare -F print_header >/dev/null 2>&1; then
        # shellcheck source=/dev/null
        source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install_utils.sh"
    fi
}

main_linux()
{
    _maybe_source_utils

    print_header "Running Linux installer...\n"

    # Prefer the caller-provided dotfiles_dir; otherwise fall back to script dir
    local df
    df="${dotfiles_dir:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    if [[ -z "${dotfiles_dir:-}" ]]; then
        # Only set when not already provided by the caller
        dotfiles_dir="${df}"
    fi

    print_info "Dotfiles directory: ${dotfiles_dir}\n"

    print_header "Symlinking files (linux)...\n"
    symlink_file "bashrc"
    symlink_file "bash_profile"
    symlink_file "scripts"
    symlink_file "tmux.conf"
    symlink_file "vim"
    symlink_file "local/share/fonts"
    symlink_file "config/wezterm"
    symlink_file "config/nvim"

    print_success "Done installing dotfiles (linux).\n"
}

