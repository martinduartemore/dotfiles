DOTFILES_DIR="${HOME}/dotfiles"

# exports
if [ -f "${DOTFILES_DIR}/zsh/exports" ]; then
    source "${DOTFILES_DIR}/zsh/exports"
fi

# aliases
if [ -f "${DOTFILES_DIR}/zsh/aliases" ]; then
    source "${DOTFILES_DIR}/zsh/aliases"
fi

# prompt
if [ -f "${DOTFILES_DIR}/zsh/prompt" ]; then
    source "${DOTFILES_DIR}/zsh/prompt"
fi

# custom
if [ -f "${DOTFILES_DIR}/zsh/custom" ]; then
    source "${DOTFILES_DIR}/zsh/custom"
fi

# PATH additions
PATH="${PATH}:${HOME}/.scripts"
export PATH
