# -------------------
# Set up the prompt
# -------------------
autoload -Uz colors && colors
colors

autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_git_get_users

__PWD=""
function chpwd_git_get_users() {
  __GLOBAL_GIT_USER="`git config --global user.name` <`git config user.email`>"
  __CURRENT_GIT_USER="`git config user.name` <`git config user.email`>"
  if [[ -e ./.git ]]; then
    if [[ "$__PWD" == "" ]] || [[ "$__PWD" != "$PWD" ]]; then
      __PWD=$PWD;
      echo "$fg[yellow]Global git user:$reset_color" \
          "$fg_bold[red]$__GLOBAL_GIT_USER$reset_color";
      echo "$fg[yellow]Current git user:$reset_color" \
          "$fg_bold[red]$__CURRENT_GIT_USER$reset_color";
    fi
  fi
}

# -------------------
# Prompt
# -------------------


PS1="%{$fg_bold[cyan]%}﹝%{$reset_color%}%{$fg_bold[blue]%}%~%{$reset_color%}%{$fg_bold[cyan]%}﹞%{$reset_color%}%{$fg_bold[white]%}▹%{$reset_color%}%{$fg[red]%}▷ "
RPROMPT="⚫%{$reset_color%}%{$bg[black]%}%{$fg_bold[white]%}%m%{$reset_color%}"


# -------------------
# Set optinons
# -------------------
setopt sharehistory menucomplete correctall
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt inc_append_history                                       # save commands are added to the history immediately, otherwise only when shell exits.
setopt histignorespace                                          # Don't save commands that start with space
setopt PROMPT_SUBST                                             # Allow for functions in the prompt.

# -------------------
# Use modern completion system
# -------------------
fpath+=$HOME/.zfunc

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
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*' # Case insensitive tab completion
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Speed up completions 
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache 


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
# Help command
# -------------------
autoload -U run-help
autoload run-help-git


# -------------------
# Exports
# -------------------
export EDITOR="vim"
export PATH=$PATH:/usr/sbin:/usr/local/go/bin:$HOME/go/bin


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
alias help='run-help'
alias ip='ip --color=auto'
alias pacman='pacman --color=auto'


# -------------------
# TMUX setup
# -------------------

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux
fi


# -------------------
# Plugins
# -------------------
# Use syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use history substring search
source /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh
# Use autosuggesions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
zmodload zsh/terminfo

