# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/fkling/.zshrc'

# End of lines added by compinstall

#
# Prompt
#

autoload -U colors
colors

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr " %{$fg[green]%}●%{$reset_color%}" # default 'S'
zstyle ':vcs_info:*' unstagedstr " %{$fg[red]%}●%{$reset_color%}" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'
zstyle ':vcs_info:hg*:*' formats '[%m%b] '
zstyle ':vcs_info:hg*:*' actionformats '[%b|%a%m] '
zstyle ':vcs_info:hg*:*' branchformat '%b'
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-revision true
zstyle ':vcs_info:hg*:*' get-mq false
zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks
zstyle ':vcs_info:hg*+set-message:*' hooks hg-message

function +vi-hg-bookmarks() {
  if [[ -n "${hook_com[hg-active-bookmark]}" ]]; then
    hook_com[hg-bookmark-string]="${(Mj:,:)@}"
    ret=1
  fi
}

function +vi-hg-message() {
  # Suppress hg branch display if we can display a bookmark instead.
  if [[ -n "${hook_com[misc]}" ]]; then
    hook_com[branch]=''
  fi
  return 0
}

function +vi-git-untracked() {
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+=" %{$fg[blue]%}●%{$reset_color%}"
  fi
}

setopt PROMPT_SUBST
export PS1="%{$fg[green]%}${SSH_TTY:+%n@%m }%{$reset_color%}%{$fg[blue]%}%T %{$reset_color%}%{$fg[yellow]%}%c %{$fg[red]%}%(!.#.$)%{$reset_color%} "
export RPROMPT="\${vcs_info_msg_0_}%{$fg[blue]%}%~%{$reset_color%}"
export SPROMPT="zsh: correct %{$fg[red]%}'%R'%{$reset_color%} to %{$fg[red]%}'%r'%{$reset_color%} [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

#
# History
#

export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

#
# Options
#

setopt autocd               # .. is shortcut for cd .. (etc)
setopt autoparamslash       # tab completing directory appends a slash
setopt autopushd            # cd automatically pushes old dir onto dir stack
setopt clobber              # allow clobbering with >, no need to use >!
setopt correct              # command auto-correction
setopt correctall           # argument auto-correction
setopt noflowcontrol        # disable start (C-s) and stop (C-q) characters
setopt nonomatch            # unmatched patterns are left unchanged
setopt histignorealldups    # filter duplicates from history
setopt histignorespace      # don't record commands starting with a space
setopt histverify           # confirm history expansion (!$, !!, !foo)
setopt ignoreeof            # prevent accidental C-d from exiting shell
setopt interactivecomments  # allow comments, even in interactive shells
setopt printexitvalue       # for non-zero exit status
setopt pushdignoredups      # don't push multiple copies of same dir onto stack
setopt pushdsilent          # don't print dir stack after pushing/popping
setopt sharehistory         # share history across shells

#
# Bindings
#

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "\e[A" history-beginning-search-backward-end  # cursor up
bindkey "\e[B" history-beginning-search-forward-end   # cursor down

autoload -U select-word-style
select-word-style bash # only alphanumeric chars are considered WORDCHARS

bindkey ' ' magic-space # do history expansion on space

#
# Other
#

source $HOME/.shells/aliases
source $HOME/.shells/path
source $HOME/.shells/functions

## nvm
has_homebrew=$(command -v brew)

if [ -n "$has_homebrew" ]; then
  export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh
elif [ -f ~/.nvm/nvm.sh ]; then
  export NVM_DIR=~/.nvm
  source ~/.nvm/nvm.sh
fi



## vi mode for bash
set -o vi

## editor
export EDITOR="vim"

# more completion
if [[ -n "$has_homebrew" ]];  then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

#
# Hooks
#

autoload -U add-zsh-hook

function set-window-title() {
  print -Pn "\e]2;$1\a"
}

function set-tab-title() {
  print -Pn "\e]1;$1\a"
}

function set-tab-and-window-title() {
  print -Pn "\e]0;$1\a"
}

function update-window-title-precmd() {
  set-tab-and-window-title `history | tail -1 | cut -b8-`
}
add-zsh-hook precmd update-window-title-precmd

function update-window-title-preexec() {
  emulate -L zsh
  setopt extended_glob

  # skip ENV=settings, sudo, ssh; show first distinctive word of command;
  # mostly stolen from:
  #   https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
  set-tab-and-window-title ${2[(wr)^(*=*|ssh|sudo)]}
}
add-zsh-hook preexec update-window-title-preexec

# for prompt
add-zsh-hook precmd vcs_info

# include local files
test -f ~/.zshrc.local && source ~/.zshrc.local
function update-hostname() {
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    HOSTNAME="`whoami`@`hostname -s` "
  else
    HOSTNAME=""
  fi
}

autoload -Uz compinit
compinit
