# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Key bindings
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

cdParentKey() {
  cd ..
  zle      reset-prompt
}

zle -N                 cdParentKey
bindkey '^[[1;3A'      cdParentKey

## Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
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
setopt histverify
setopt correct #correctall
setopt promptsubst
unsetopt beep

# Use modern completion system
autoload -Uz compinit
compinit

# Words are alphanumeric characters only
autoload -U select-word-style
select-word-style bash

export PATH=$PATH:$HOME/.yarn/bin

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
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin  \
                                           /usr/sbin       \
                                           /usr/bin        \
                                           /sbin           \
                                           /bin            \
                                           /usr/X11R6/bin

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# VCS
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn cvs hg bzr
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' actionformats \
 '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{10}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
 '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{10}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' hgrevformat '%r'
precmd () { vcs_info }

# Prompt
PROMPT="%F{10}%B%n@%M%f:%F{12}%3~%f%#%b "
#PROMPT="%{$fg[green]%}%B%n@%M%{$reset_color%}:%{$fg[blue]%}%3~%{$reset_color%}%#%b "
RPROMPT='${vcs_info_msg_0_}'
SPROMPT="zsh: correct '%R' to '%r'? [ynea]"

# Environment
export EDITOR=nvim
export VISUAL=nvim

colorize_via_pygmentize() {
    if [ ! -x "$(which pygmentize)" ]; then
        echo "package \'Pygments\' is not installed!"
        return -1
    fi

    if [ $# -eq 0 ]; then
        pygmentize -g $@
    fi

    for FNAME in $@
    do
        filename=$(basename "$FNAME")
        lexer=`pygmentize -N \"$filename\"`
        if [ "Z$lexer" != "Ztext" ]; then
            pygmentize -l $lexer "$FNAME"
        else
            pygmentize -g "$FNAME"
        fi
    done
}
alias ccat='colorize_via_pygmentize'

function man() {
        env \
                LESS_TERMCAP_mb=$(printf "\e[1;31m") \
                LESS_TERMCAP_md=$(printf "\e[1;31m") \
                LESS_TERMCAP_me=$(printf "\e[0m") \
                LESS_TERMCAP_se=$(printf "\e[0m") \
                LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
                LESS_TERMCAP_ue=$(printf "\e[0m") \
                LESS_TERMCAP_us=$(printf "\e[1;32m") \
                PAGER="${commands[less]:-$PAGER}" \
                _NROFF_U=1 \
                        man "$@"
}

# Check for virtualenvwrapper
if type workon >/dev/null 2>&1; then
  VENV_WRAPPER=true
else
  VENV_WRAPPER=false
fi

function _virtualenv_auto_activate() {
    if [ -e ".venv" ]; then
        # Check for symlink pointing to virtualenv
        if [ -L ".venv" ]; then
          _VENV_PATH=$(readlink .venv)
          _VENV_WRAPPER_ACTIVATE=false
        # Check for directory containing virtualenv
        elif [ -d ".venv" ]; then
          _VENV_PATH=$(pwd -P)/.venv
          _VENV_WRAPPER_ACTIVATE=false
        # Check for file containing name of virtualenv
        elif [ -f ".venv" -a $VENV_WRAPPER = "true" ]; then
          _VENV_PATH=$WORKON_HOME/$(cat .venv)
          _VENV_WRAPPER_ACTIVATE=true
        else
          return
        fi

        # Check to see if already activated to avoid redundant activating
        if [ "$VIRTUAL_ENV" != $_VENV_PATH ]; then
            if $_VENV_WRAPPER_ACTIVATE; then
              _VENV_NAME=$(basename $_VENV_PATH)
              workon $_VENV_NAME
            else
              _VENV_NAME=$(basename `pwd`)
              VIRTUAL_ENV_DISABLE_PROMPT=1
              source .venv/bin/activate
              _OLD_VIRTUAL_PS1="$PS1"
              PS1="($_VENV_NAME)$PS1"
              export PS1
            fi
            echo Activated virtualenv \"$_VENV_NAME\".
        fi
    fi
}

function dotenv() {
    if [ -f "$1" ]; then
        ENV_VARS="$(cat "$1" | awk '!/^\s*#/' | awk '!/^\s*$/')"
        eval "$(
        printf '%s\n' "$ENV_VARS" | while IFS='' read -r line; do
            key=$(printf '%s\n' "$line"| sed 's/"/\\"/g' | cut -d '=' -f 1)
            value=$(printf '%s\n' "$line" | cut -d '=' -f 2- | sed 's/"/\\\"/g')
            printf '%s\n' "export $key=\"$value\""
        done
        )"
    else
        echo File "$1" does not exist
    fi
}

export PROMPT_COMMAND=_virtualenv_auto_activate
if [ -n "$ZSH_VERSION" ]; then
  function chpwd() {
    _virtualenv_auto_activate
  }
fi


# Aliases
alias vim='nvim'
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
alias t='tail -f'
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
alias clogin='sudo -u rancid /usr/lib/rancid/bin/clogin'

# On start
date "+%A %d %B %T %Y"
