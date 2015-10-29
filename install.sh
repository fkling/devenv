#!/bin/bash

# 1. Sets up a local Python environment via virtualenv
# 2. Installs Ansible prerequisites
# 3. Hands off to Ansible to complete actual installation of dotfiles etc

set -e

ANSIBLE_ENV_SETUP=vendor/ansible/hacking/env-setup
VIRTUALENV_SETUP=vendor/virtualenv/virtualenv.py
VIRTUALENV_TARGET_DIR=python
VIRTUALENV_ACTIVATE=$VIRTUALENV_TARGET_DIR/bin/activate


usage() {
  echo "./install [options] [roles...]"
  echo "Supported options:"
  echo "  -f/--force"
  echo "  -h/--help"
  echo "  -v/--verbose (repeat for more verbosity)"
  echo "Supported roles:"
  for ROLE in $(ls roles); do
    echo "  $ROLE"
    echo "    $(cat roles/$ROLE/description)"
  done
}

while [ $# -gt 0 ]; do
  if [ "$1" = '--force' -o "$1" = '-f' ]; then
    FORCE=1
  elif [ "$1" = '--verbose' -o "$1" = '-v' ]; then
    VERBOSE=$((VERBOSE + 1))
  elif [ "$1" = '--help' -o "$1" = '-h' -o "$1" = 'help' ]; then
    usage
    exit
  elif [ -n "$1" ]; then
    if [ -d "roles/$1" ]; then
      if [ -z "$ROLES" ]; then
        ROLES="--tags $1"
      else
        ROLES="$ROLES,$1"
      fi
    else
      echo "Unrecognized argument(s): $*"
      usage
      exit 1
    fi
  fi
  shift
done

if [[ $VERBOSE ]]; then
  DEV_NULL=/dev/stdout
  if [ $VERBOSE -gt 1 ]; then
    echo 'Enabling extremely verbose output'
    set -x
  fi
else
  trap 'echo "Exiting: run with -v/--verbose for more info"' EXIT
  DEV_NULL=/dev/null
fi

if [ ! -e $VIRTUALENV_SETUP ]; then
  echo "Not found: $VIRTUALENV_SETUP"
  echo "Did you forget to 'git submodule update --init --recursive'?"
  exit 1
fi

if [ ! -e $ANSIBLE_ENV_SETUP ]; then
  echo "Not found: $ANSIBLE_ENV_SETUP"
  echo "Did you forget to 'git submodule update --init --recursive'?"
  exit 1
fi

if [[ ! -e $VIRTUALENV_ACTIVATE || $FORCE ]]; then
  python $VIRTUALENV_SETUP $VIRTUALENV_TARGET_DIR &> $DEV_NULL
elif [ -e $VIRTUALENV_ACTIVATE ]; then
  echo "Skipping virtualenv install (already exists); use --force to override"
fi

source $VIRTUALENV_ACTIVATE

if [[ -z $(pip show paramiko PyYAML Jinja2 httplib2) || $FORCE ]]; then
  if ! pip install paramiko PyYAML Jinja2 httplib2 six &> $DEV_NULL; then
    echo "Failed: pip install"
    echo "Did you forget to 'export https_proxy=fwdproxy:8080' or similar?"
    exit 1
  fi
elif [[ ! $FORCE ]]; then
  echo "Skipping pip installs (already exists); use --force to override"
fi

source vendor/ansible/hacking/env-setup &> $DEV_NULL

HOST_OS=$(uname)

if [ "$HOST_OS" = 'Darwin' ]; then
  ansible-playbook --ask-become-pass -i inventory ${VERBOSE+-v} ${ROLES} darwin.yml
elif [ "$HOST_OS" = 'Linux' ]; then
  ansible-playbook --ask-become-pass -i inventory ${VERBOSE+-v} ${ROLES} linux.yml
else
  echo "Unknown host OS: $HOST_OS"
  exit 1
fi

trap - EXIT
