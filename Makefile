ROOT_PATH := $(shell sh -c 'pwd')

all:
	git submodule update --init
	ln -fs ${ROOT_PATH}/vimrc ~/.vimrc
	ln -fs ${ROOT_PATH}/vim ~/.vim -T

update:
	git submodule foreach "(git checkout master; git pull)"
