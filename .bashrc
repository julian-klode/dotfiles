# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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
    xterm-color) color_prompt=yes;;
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
if [ -e "/etc/bash_completion.d/git" -a -e "/usr/bin/git" ]; then
	PS1=${PS1:0:-3}'$(__git_ps1 ":%s")\$ '
fi

# Passed command and arguments, run the command, and set GIT_DIR=.hgit if
# the current directory is $HOME.
_run_git() {
    local env=env
    if [ "$PWD" = "$HOME" ]; then
	env="env GIT_DIR=.hgit"
    fi

    if [ -z "$($env git config --local --get user.email)" ]; then
	echo "WARNING: No email adress specified" >&2
    fi

    $env "$@"

    if [ -z "$($env git config --local --get user.email)" ]; then
	echo "WARNING: No email adress specified" >&2
    fi
}

# Debugging and development aliases aliases
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

alias math="MUTT_ACCOUNT=math mutt"
alias stud="MUTT_ACCOUNT=students mutt"
alias marburg="MUTT_ACCOUNT=students mutt"
alias news="MUTT_ACCOUNT=news mutt"
alias gmane="MUTT_ACCOUNT=news mutt"

alias mr="mr -j5"
alias kvm="qemu-system-x86_64 -enable-kvm"


if [ -e /etc/profile.d/vte.sh ]; then
    . /etc/profile.d/vte.sh
fi


# Seriously: Automatic proxy for curl, wget, aria2c!
unset HTTP_PROXY
unset NO_PROXY
with_proxy() {
    http_proxy=$(echo http://example.com | proxy)
    if [ "$http_proxy" = "direct://" ]; then
	"$@"
    else
	env "http_proxy=$http_proxy" "$@"
    fi
}

alias curl="with_proxy curl"
alias wget="with_proxy wget"
alias aria2c="with_proxy aria2c"

readahead() {
    pv "$@" > /dev/null
}

play() {
    readahead "$@"
    vlc "$@"
}
