if status is-interactive
    /opt/homebrew/bin/brew shellenv | source
    zoxide init fish | source
    fzf --fish | source
    # Commands to run in interactive sessions can go here
end
