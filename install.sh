#!/bin/bash

DIR=~/dotfiles

install_vim()
{
	echo "Installing VIM configurations..."

	# Cleanup old vim configurations
	if [ -f ~/.vim ]; then
		rm ~/.vim
	fi

	# Copy new vim configurations
	ln -fs $DIR/vim ~/.vim
	ln -fs $DIR/vimrc ~/.vimrc

	echo "Done installing VIM."
}

install()
{
	install_vim
}

install
