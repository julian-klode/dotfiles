# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# Set the default path to the one for root, with games added
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes ccache binaries if installed
if [ -d /usr/lib/ccache ]; then
    export PATH="/usr/lib/ccache:$PATH"
    export CCACHE_DIR="$HOME/.cache/ccache"
fi

# Setup stuff for email and co
export EDITOR="editor"
export EMAIL="Julian Andres Klode <jak@debian.org>"
export DEBEMAIL="jak@debian.org"

# Android development
export PATH=$HOME/Android/Sdk/platform-tools:$PATH
# Go development
export GOPATH="$HOME/Projects/Go"
# CMake
export CTEST_OUTPUT_ON_FAILURE=1

_byobu_sourced=1 . /usr/bin/byobu-launch
