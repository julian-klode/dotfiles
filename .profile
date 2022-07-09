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
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/snap/bin"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes ccache binaries if installed
if [ -d /usr/lib/ccache ]; then
    export PATH="/usr/lib/ccache:$PATH"
fi

# Setup stuff for email and co
export EDITOR="editor"
if dpkg-vendor --derives-from ubuntu; then
	export EMAIL="Julian Andres Klode <juliank@ubuntu.com>"
	export DEBEMAIL="juliank@ubuntu.com"
else
	export EMAIL="Julian Andres Klode <jak@debian.org>"
	export DEBEMAIL="jak@debian.org"
fi

# Android development
export PATH=$HOME/Android/Sdk/platform-tools:$PATH
# Go development
export GOPATH="$HOME/Projects/Go"
export PATH="$GOPATH/bin:$PATH"
# CMake
export CTEST_OUTPUT_ON_FAILURE=1

# Qt sucks
export QT_STYLE_OVERRIDE=Adwaita-Dark

# Ccache
export CCACHE_DIR=$HOME/.ccache

# lto is slow, me no like
export DEB_BUILD_OPTIONS=optimize=-lto

_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
