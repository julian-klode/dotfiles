set fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
end
if not set -q VSCODE_CWD;   status --is-login; and status --is-interactive; and exec byobu-launcher;end
