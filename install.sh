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
	install_vim
}

install
