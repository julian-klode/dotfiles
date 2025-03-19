function hgit
    command git --git-dir=$HOME/.hgit --work-tree=$HOME $argv
end
function git
    if test (pwd) =  /home/jak
        hgit $argv
    else
        command git $argv
    end
end
