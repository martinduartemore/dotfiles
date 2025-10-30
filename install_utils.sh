#!/usr/bin/env bash
# Utility functions for installers. This file is intended to be sourced by
# `install.sh` and the OS-specific installers. It only defines functions and
# should not perform side-effects at load time.

print_header()  { printf "\e[1;37m%b\e[0m" "$*"    ; }
print_success() { printf "\e[1;32m[v]\e[0m %b" "$*"; }
print_error()   { printf "\e[1;31m[x]\e[0m %b" "$*"; }
print_info()    { printf "\e[1;36m[>]\e[0m %b" "$*"; }
print_ask()     { printf "\e[1;33m[?]\e[0m %b" "$*"; }

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
    local src_name="${1}"
    local src_path="${dotfiles_dir}/${src_name}"
    local dst_path="${HOME}/.${src_name}"

    print_info "${src_path}\n"

    print_info "    Deleting ${dst_path}\n"
    rm -rf "${dst_path}"

    print_info "    Linking ${src_path} to ${dst_path}\n"
    # ensure the destination parent directory exists (e.g. ~/.config)
    mkdir -p "$(dirname "${dst_path}")"

    if [[ -e "${src_path}" || -L "${src_path}" ]]; then
        ln -s "${src_path}" "${dst_path}"
    else
        print_error "Source path does not exist: ${src_path}\n"
        return 1
    fi

    print_success "    ${src_path} --> ${dst_path}\n"
}
