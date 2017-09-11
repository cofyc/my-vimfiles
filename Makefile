ROOT := $(shell sh -c 'pwd')

all:
	ln -fs ${ROOT}/vimrc ~/.vimrc
	ln -fs ${ROOT}/vim ~/.vim -T

standalone:
	ln -fs ${ROOT}/vimrc.standalone ~/.vimrc

update:
	git submodule foreach "(git checkout master; git pull)"
