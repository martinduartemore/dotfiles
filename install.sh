#!/usr/bin/env bash
set -o errexit
set -o nounset

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install_utils.sh"


main()
{
    print_header "Gathering system information...\n"
    declare -r os="$(get_os)"
    # dotfiles_dir is used by symlink_file; set it once here and make available
    # to the OS-specific installers.
    declare -r dotfiles_dir="$(script_dir)"
    print_info "Operating system: ${os}\n"
    print_info "Home directory: ${HOME}\n"
    print_info "Dotfiles directory: ${dotfiles_dir}\n"

    case "${os}" in
        macos)
            if [[ -f "${dotfiles_dir}/install_mac.sh" ]]; then
                # shellcheck source=/dev/null
                source "${dotfiles_dir}/install_mac.sh"
                main_mac "$@"
            else
                print_error "macOS installer (install_mac.sh) not found.\n"
                exit 1
            fi
            ;;
        linux)
            if [[ -f "${dotfiles_dir}/install_linux.sh" ]]; then
                # shellcheck source=/dev/null
                source "${dotfiles_dir}/install_linux.sh"
                main_linux "$@"
            else
                # fallback: perform the original symlinks but skip mac/unix-specific items
                print_error "Linux installer (install_linux.sh) not found.\n"
                exit 1
            fi
            ;;
        *)
            print_error "Unsupported OS: ${os}\n"
            exit 1
            ;;
    esac
}


main "$@"
