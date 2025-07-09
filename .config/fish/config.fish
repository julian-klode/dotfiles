set fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
end
if not set -q ZELLIJ; and status --is-interactive; and exec zellij attach -c;end
