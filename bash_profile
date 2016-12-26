# TODO: maybe switch to use .profile later

# exports
source ~/dotfiles/bash/exports

# path
PATH="${PATH}:${HOME}/bin:${HOME}/.local/bin"


# load .bashrc file
if [[ -f "${HOME}/.bashrc" ]]; then
    source "${HOME}/.bashrc"
fi
