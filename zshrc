# -------------------
# Set up the prompt
# -------------------
autoload -Uz colors && colors
colors


PS1="%{$fg_bold[cyan]%}﹝%{$reset_color%}%{$fg_bold[blue]%}%~%{$reset_color%}%{$fg_bold[cyan]%}﹞%{$reset_color%}%{$fg_bold[white]%}▹%{$reset_color%}%{$fg[red]%}▷ "
RPROMPT="⚫%{$reset_color%}%{$bg[black]%}%{$fg[white]%}%M%{$reset_color%}"

# -------------------
# Set optinons
# -------------------
setopt histignorealldups sharehistory menucomplete correctall

# -------------------
# Use emacs keybindings even if our EDITOR is set to vi
# -------------------
bindkey -e


# -------------------
# Keep 500 lines of history within the shell and save it to ~/.zsh_history:
# -------------------
HISTSIZE=500
SAVEHIST=500
HISTFILE=~/.zsh_history


# -------------------
# Use modern completion system
# -------------------
autoload -U compinit && compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=1 _complete _ignored _approximate _correct
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# -------------------
# Help command
# -------------------
autoload -U run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-svk
alias help=run-help


# -------------------
# Exports
# -------------------
export EDITOR="vim"


# -------------------
# Window title
# -------------------
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      print -Pn "\e]0;%n@%M %~%#\a"
    }
    preexec () { print -Pn "\e]0;%~%# ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () {
      vcs_info
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
    }
    preexec () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
    }
    ;;
esac

# -------------------
# Aliases
# -------------------
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ttime='/usr/bin/time'

# -------------------
# TMUX setup
# -------------------

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

