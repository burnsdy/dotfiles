#!/bin/bash


if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	cat utils_lists/* | xargs sudo apt-get install -y 
fi
