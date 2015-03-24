## Color settings
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad


## Prompt
# http://blog.bitfluent.com/post/27983389/git-utilities-you-cant-live-without
# http://superuser.com/questions/31744/how-to-get-git-completion-bash-to-work-on-mac-os-x

function __git_prompt {
  GIT_PS1_SHOWDIRTYSTATE=1
  [ `git config user.pair` ] && GIT_PS1_PAIR="`git config user.pair`@"
  __git_ps1 " $GIT_PS1_PAIR%s" | sed 's/ \([+*]\{1,\}\)$/\1/'
}

# Only show username@server over SSH.
function __name_and_server {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    echo "`whoami`@`hostname -s` "
  fi
}

bash_prompt() {

  # regular colors
  local K="\[\033[0;30m\]" # black
  local R="\[\033[0;31m\]" # red
  local G="\[\033[0;32m\]" # green
  local Y="\[\033[0;33m\]" # yellow
  local B="\[\033[0;34m\]" # blue
  local M="\[\033[0;35m\]" # magenta
  local C="\[\033[0;36m\]" # cyan
  local W="\[\033[0;37m\]" # white

  # emphasized (bolded) colors
  local BK="\[\033[1;30m\]"
  local BR="\[\033[1;31m\]"
  local BG="\[\033[1;32m\]"
  local BY="\[\033[1;33m\]"
  local BB="\[\033[1;34m\]"
  local BM="\[\033[1;35m\]"
  local BC="\[\033[1;36m\]"
  local BW="\[\033[1;37m\]"

  # reset
  local RESET="\[\033[0;39m\]"

  PS1="$B\t $BY\$(__name_and_server)$Y\W$R\$(__git_prompt)$RESET ∮ "

}

bash_prompt
unset bash_prompt


## History
# keep lots of commands in the history, both in memory and on disk
export HISTSIZE=10000
export HISTFILESIZE=10000
# omit consecutive duplicates from the history list
export HISTCONTROL=ignoredups
export HISTIGNORE="exit"

## Shell options
# prevent accidental CTRL-D from exiting the shell (multiple CTRL-Ds will still work)
set -o ignoreeof
# silently correct typos in directory names when using the "cd" builtin
shopt -s cdspell
# append to the history file rather than overwriting it
shopt -s histappend
# allow user to verify that a history substitution is correct before executing
shopt -s histverify
# use extended globbing (for example, needed in the _man() function)
shopt -s extglob
# don't use host completion on words containing the "@" symbol (because it interferes with my ssh completion below)
shopt -u hostcomplete

## Environment
source $HOME/.shells/aliases
source $HOME/.shells/path
source $HOME/.shells/functions

## Title bar

OPENTITLEBAR="\033]0;"
CLOSETITLEBAR="\007"
trap 'printf "${OPENTITLEBAR}`history 1 | cut -b8- | sed 's/%/%%/g'`${CLOSETITLEBAR}"' DEBUG

## Completions
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# whereis completes on commands
# (not so useful seeing as whereis only searches standard binary dirs, not user
# PATH)
complete -c command whereis

## nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

## Load host specific bash settings
test -f ~/.bashrc.local && source ~/.bashrc.local
