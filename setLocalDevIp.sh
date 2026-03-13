#!/bin/zsh

# set local ip for Docker to connect back from PHP xDebug to the IDE
sudo ifconfig lo0 alias 129.0.0.1/24 up