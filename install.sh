#!/bin/bash

DIR=~/dotfiles

install_vim()
{
	if [ -f ~/.vim ]; then
		rm ~/.vim
	fi
	ln -fs $DIR/vim ~/.vim
	ln -fs ~/.vim/vimrc ~/.vimrc
}

install()
{
	echo "Installing VIM configurations..."
	install_vim
	echo "Done"
}

install
