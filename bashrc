# .bashrc

# enable 256 colors support
#if [[ ${TERM} == @(screen|tmux|xterm) ]]; then
#    export OLD_TERM="${TERM}"
#    export TERM="${TERM}-256color"
#fi


# protection against non-interactive, remote shells
# if not running interactively, exit
# [[ -z "${PS1}" ]] || return 0
[[ "${-}" == *i* ]] || return 0


# shell options
shopt -s autocd         # assume 'cd' when trying to exec a directory
shopt -s cdspell        # autocorrect small typos on 'cd'
shopt -s checkwinsize   # update window size ($ROWs/$COLUMNS) after command
shopt -s cmdhist        # store multi-line commands as single history entry
shopt -s extglob        # extended glob capabilites @(...), +(...), etc.
shopt -s globstar       # the ** glob
shopt -s histappend     # append to history file, don't overwrite it
shopt -s histreedit     # allow re-editing failed history subst


# aliases
source ~/dotfiles/bash/aliases

# functions
source ~/dotfiles/bash/functions

# prompt
source ~/dotfiles/bash/prompt
