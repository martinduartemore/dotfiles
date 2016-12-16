#!/usr/bin/env bash
set -o errexit
set -o nounset

declare -r DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )\n" 

get_os() {
	declare -r OS_NAME="$(uname -s)"
	local os=""

	if [ "${OS_NAME}" = "Linux" ]; then
		os="Linux"
	elif []; then
		os="OSX"
	fi

	printf "Operating system: %s\n" "${os}"
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
	install_vim
}

install
