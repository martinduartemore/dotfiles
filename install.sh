#!/usr/bin/env bash
set -o errexit
set -o nounset

# logging
print_header()  { printf "\e[1;37m${@}\e[0m"    ; }
print_success() { printf "\e[1;32m[v]\e[0m ${@}"; }
print_error()   { printf "\e[1;31m[x]\e[0m ${@}"; }
print_info()    { printf "\e[1;36m[>]\e[0m ${@}"; }
print_ask()     { printf "\e[1;33m[?]\e[0m ${@}"; }


# utils
script_dir() { printf "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; }

is_root() { [[ "${EUID}" = 0 ]]; }

get_os()
{
    local os=""
    
    case "${OSTYPE}" in
        linux*)     os="linux"  ;;
        darwin*)    os="macos"  ;;
        *)          os="unknown";;
    esac

    printf "%s" "${os}"
}

symlink_file()
{
    print_info "Attempting to symlink \"${1}\"\n"
    local src="${dotfiles_dir}/${1}"
    local dst="${HOME}/.${1}"

    print_info "Deleting ${dst}\n"
    rm -rf "${dst}"

    print_info "Copying ${src} to ${dst}\n"
    ln -s "${src}" "${dst}"
}


main()
{
    print_header "Gathering system information...\n"
    declare -r os="$(get_os)"
    declare -r dotfiles_dir="$(script_dir)" 
    print_info "Operating system: ${os}\n"
    print_info "Home directory: ${HOME}\n"
    print_info "Dotfiles directory: ${dotfiles_dir}\n"

    print_header "Symlinking files...\n"
    symlink_file "vim"
    symlink_file "bashrc"
    symlink_file "bash_profile"

    print_success "Done installing dotfiles!\n"
}

main "${@}"
