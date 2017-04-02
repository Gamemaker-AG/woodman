.PHONY: default clean build run package-linux package-windows package-mac package

default: run

NAME=woodman

buildclean:
	rm -f $(NAME).love

clean:
	rm -f $(NAME).love
	rm -rf pkg
	rm -rf lib

$(NAME).love: buildclean
	@zip -q $(NAME).love main.lua conf.lua
	@zip -q -r -0 $(NAME).love assets/*
	@zip -q -r $(NAME).love src/*

build: $(NAME).love

run: $(NAME).love
	@love $(NAME).love

setup:
	git submodule update --init --recursive

package-linux: build
	@./script/download.sh linux
	@./script/package.sh linux

package-windows: build
	@./script/download.sh windows
	@./script/package.sh windows

package-osx: build
	@./script/download.sh osx
	@./script/package.sh osx

subupdate:
	git submodule foreach git pull origin master

package: build package-linux package-windows package-mac

zip: package
	cd pkg && zip -q -r space_narcade.zip ./*
