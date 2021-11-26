#!/bin/bash

# macOS
if [ "$(expr substr $(uname -s) 1 6)" == "Darwin" ]; then
	cat utils_lists/general.txt utils_lists/mac.txt | xargs brew install
fi

# Linux
if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	cat utils_lists/general.txt utils_lists/linux.txt | xargs sudo apt-get install -y 
	if ! [ "$(command -v bat &> /dev/null)" ]; then
		mkdir -p ~/.local/bin
		ln -s /usr/bin/batcat ~/.local/bin/bat
	fi
fi
