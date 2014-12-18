ROOT_PATH := $(shell sh -c 'pwd')

all:
	git submodule update --init --recursive
	ln -fs ${ROOT_PATH}/vimrc ~/.vimrc
	ln -fs ${ROOT_PATH}/vim ~/.vim -T

standalone:
	ln -fs ${ROOT_PATH}/vimrc.standalone ~/.vimrc

update:
	git submodule foreach "(git checkout master; git pull)"
