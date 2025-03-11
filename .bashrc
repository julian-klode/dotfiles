# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
ulimit -n 1024

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add git status to the terminal prompt
if set 2>/dev/null | grep -q '__git_ps1 *('; then
	PS1=${PS1:0:-3}'$(__git_ps1 ":%s")\$ '
fi

# Passed command and arguments, run the command, and set GIT_DIR=.hgit if
# the current directory is $HOME.
_run_git() {
    local env=env
    if [ "$PWD" = "$HOME" ]; then
	env="env GIT_DIR=.hgit"
    fi

    if echo $PWD | grep -q Ubuntu; then
	env="$env GIT_AUTHOR_EMAIL=julian.klode@canonical.com GIT_COMMITTER_EMAIL=julian.klode@canonical.com EMAIL=julian.klode@canonical.com"
    elif echo "$@" | egrep -q 'commit|push'; then
	if [ -z "$($env git config --local --get user.email)" ]; then
	    echo "ERROR: No email adress specified" >&2
	    return 1
	fi
    fi

    $env "$@"
}

# Debugging and development aliases aliases
alias hgit="command git --git-dir=$HOME/.hgit --work-tree=$HOME"
alias valgrind="dbg-env valgrind"
alias gdb="dbg-env gdb"
alias strace="dbg-env strace"
alias ltrace="dbg-env ltrace"
alias lte="libtool --mode=execute"

# Set rm to use gvfs-trash, this helps a lot
for tool in gvfs-trash trash-put; do
    [ ! -e /usr/bin/$tool ] || alias rm=/usr/bin/$tool
done

# Aliases for git and gitg to use the __run_git helper above
alias git="_run_git git"
alias gitg="_run_git gitg"

alias debsign="debsign -kjak@debian.org"
alias diff="git diff --no-index --no-prefix"

alias can="env NOTMUCH_CONFIG=/home/jak/mail.canonical/.notmuch-config mutt -F ~/.mutt/account.canonical-notmuch"
alias math="mutt -F ~/.mutt/account.math"
alias stud="mutt -F ~/.mutt/account.students"
alias marburg="mutt -F ~/.mutt/account.students"
alias news="mutt -F ~/.mutt/account.news"
alias gmane="mutt -F ~/.mutt/account.news"
alias imap="mutt -F ~/.mutt/account.gmail"

alias mr="mr -j5"
alias kvm="qemu-system-x86_64 -enable-kvm"

# Seriously: Automatic proxy for curl, wget, aria2c!
unset HTTP_PROXY http_proxy
unset HTTPS_PROXY https_proxy
unset NO_PROXY no_proxy
with_proxy() {
    http_proxy=$(echo http://example.com | proxy)
    if [ "$http_proxy" = "direct://" ]; then
	env -u http_proxy "$@"
    else
	env "http_proxy=$http_proxy" "$@"
    fi
}

# Download tools
alias curl="with_proxy curl"
alias wget="with_proxy wget"
alias aria2c="with_proxy aria2c"

# Random stuff
readahead() {
    pv "$@" > /dev/null
}

play() {
    readahead "$@"
    vlc "$@"
}

striparch() {
    new="${1/amd64/all}"
    mergechanges -i "$1" "$1" | sponge "$new"
}

atom() {
    command atom $(git rev-parse --show-toplevel 2>/dev/null) "$@"
    return $?
}

# Python
alias python=python3
alias ipython=ipython3
alias ipython2=/usr/bin/ipython
alias pydoc=pydoc3
alias pydoc2=/usr/bin/pydoc

# Ubuntu
alias u="env LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBEMAIL=juliank@ubuntu.com EMAIL=\"Julian Andres Klode <juliank@ubuntu.com>\" schroot -p -c devel --"
alias xenial="env LANG=C.UTF-8   LC_ALL=C.UTF-8 DEBEMAIL=juliank@ubuntu.com  EMAIL=\"Julian Andres Klode <juliank@ubuntu.com>\" schroot -p -c xenial --"
alias yakkety="env LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBEMAIL=juliank@ubuntu.com EMAIL=\"Julian Andres Klode <juliank@ubuntu.com>\" schroot -p -c yakkety --"
alias trusty="env LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBEMAIL=juliank@ubuntu.com EMAIL=\"Julian Andres Klode <juliank@ubuntu.com>\" schroot -p -c trusty --"
alias zesty="env LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBEMAIL=juliank@ubuntu.com EMAIL=\"Julian Andres Klode <juliank@ubuntu.com>\" schroot -p -c zesty --"
alias jessie="env LANG=C.UTF-8 LC_ALL=C.UTF-8 schroot -p -c jessie --"
alias ubuntu="env LANG=C.UTF-8 LC_ALL=C.UTF-8 DEB_VENDOR=ubuntu DEBEMAIL=juliank@ubuntu.com EMAIL=\"Julian Andres Klode <juliank@ubuntu.com>\""
alias debian="env LANG=C.UTF-8 LC_ALL=C.UTF-8 DEB_VENDOR=debian DEBEMAIL=jak@debian.org EMAIL=\"Julian Andres Klode <jak@debian.org>\""
alias df="df --exclude-type=tmpfs --exclude-type=devtmpfs --exclude-type=ecryptfs --exclude-type=encfs --exclude=squashfs --exclude-type=fuse"
alias cp="cp --reflink=auto"
alias pastebinit="env -i pastebinit"
alias battery-historian="podman run -p 9999:9999 gcr.io/android-battery-historian/stable:3.0 --port 9999"

#hledger() {
#    lxc exec hledger -- sudo -iu ubuntu env -C $PWD hledger "$@"
#    return $?
#}

