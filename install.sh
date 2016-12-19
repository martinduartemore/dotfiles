#!/usr/bin/env bash
set -o errexit
set -o nounset


get_script_dir()
{
	printf "%s" "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

get_os()
{
	local os=""
	
	case ${OSTYPE} in
		linux*)		os="linux" ;;
		darwin*)	os="macos" ;;
		*)			os="unknown" ;;
	esac

	printf "%s" "${os}"
}

is_root()
{
	[[ ${EUID} = 0 ]]
}

install_vim()
{
	echo "Installing VIM configurations..."

	# Cleanup old vim configurations
	if [ -f ~/.vim ]; then
		rm ~/.vim
	fi

	# Copy new vim configurations
	ln -fs $DOTFILES_DIR/vim ~/.vim
	ln -fs $DOTFILES_DIR/vimrc ~/.vimrc

	echo "Done installing VIM."
}

install()
{
	printf "Installing dotfiles...\n"

	local root_status=""
	if is_root; then root_status="[x]"; else root_status="[ ]"; fi
	printf "Root status: %s\n" "${root_status}"

	declare -r OS="$(get_os)"
	declare -r DOTFILES_DIR="$(get_script_dir)" 
	printf "Operating System: %s\n" "${OS}"
	printf "Dotfiles directory: %s\n" "$(get_script_dir)"

	install_vim
}

install
