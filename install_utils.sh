#!/bin/bash

command_exists () {
    type "$1" &> /dev/null ;
}

os="$(uname -s)"

# macOS
if [ "${os:0:6}" == "Darwin" ]; then
	if ! command_exists brew; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
	cat utils_lists/general.txt utils_lists/mac.txt | xargs brew install
fi

# Ubuntu
if [ "${os:0:5}" == "Linux" ]; then
	cat utils_lists/general.txt utils_lists/ubuntu.txt | xargs sudo apt-get install -y 
	if ! command_exists bat; then
		mkdir -p ~/.local/bin
		ln -s /usr/bin/batcat ~/.local/bin/bat
	fi
fi
