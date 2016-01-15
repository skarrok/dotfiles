# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# TMUX
if which tmux >/dev/null 2>&1; then
    # if no session is started, start a new session
    test -z ${TMUX} && (tmux attach || tmux new-session)
fi

# Key bindings
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
[[ -n "${key[Home]}"        ]] && bindkey "${key[Home]}"        beginning-of-line
[[ -n "${key[End]}"         ]] && bindkey "${key[End]}"         end-of-line
[[ -n "${key[Insert]}"      ]] && bindkey "${key[Insert]}"      owerwrite-mode
[[ -n "${key[Delete]}"      ]] && bindkey "${key[Delete]}"      delete-char
[[ -n "${key[Up]}"          ]] && bindkey "${key[Up]}"          up-line-or-history
[[ -n "${key[Down]}"        ]] && bindkey "${key[Down]}"        down-line-or-history
[[ -n "${key[Left]}"        ]] && bindkey "${key[Left]}"        backward-char
[[ -n "${key[Right]}"       ]] && bindkey "${key[Right]}"       forward-char
[[ -n "${key[PageUp]}"      ]] && bindkey "${key[PageUp]}"      beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"    ]] && bindkey "${key[PageDown]}"    end-of-buffer-or-history
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

setopt autocd
setopt appendhistory
setopt histignorealldups
setopt histignorespace
setopt incappendhistory
setopt histnostore
setopt sharehistory
setopt correct #correctall
setopt promptsubst
unsetopt beep

# Use modern completion system
autoload -Uz compinit
compinit

autoload colors && colors
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-cache true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# VCS
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn cvs hg bzr
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' actionformats \
 '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
 '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' hgrevformat '%r'
precmd () { vcs_info }

# Prompt
PROMPT="%{$fg[green]%}%B%n@%M%{$reset_color%}:%{$fg[yellow]%}%3~%{$reset_color%}%#%b "
RPROMPT='${vcs_info_msg_0_}'
SPROMPT="zsh: correct '%R' to '%r'? [ynea]"

# Environment
export EDITOR=vim
export VISUAL=vim

# Aliases
alias s='sudo -E'
alias sc='sudo systemctl'
alias jc='sudo journalctl'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias ls='ls -F --color=auto --group-directories-first'
alias ll='ls -lAhvp'
alias l='ls -lhvp'
alias lsd='ls -ld *(-/DN)'
alias lsdir='for dir in *;do;if [ -d $dir ];then;du -hsL $dir;fi;done'
alias duh="du -h --max-depth=1 | sort -h"
alias -g L='| less'
alias -g G='| grep'
alias -g GI='| grep -i'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g SU='| sort -u'
alias -g WC='| wc -l'
alias -g IC='| iconv -f cp1251 -t utf8'
alias -g IK='| iconv -f koi8r -t utf8'
alias -g ID='| iconv -f ibm866 -t utf8'
alias mc='. /usr/lib/mc/mc-wrapper.sh'

# On start
date "+%A %d %B %T %Y"

