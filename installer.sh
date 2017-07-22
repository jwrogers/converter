#!/usr/bin/env bash
# Currently a local install

# Variables
flagMan=0

# If not running as root inject sudo into critical commands
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

# Check if install location is in PATH
if [[ ! "$PATH" == ?(*:)"$HOME/.bin"?(:*) ]]; then
  echo "Add `$HOME/.bin` to your PATH or manually install"
  exit 1
fi
if [[ ! -d $HOME/.bin ]]; then
  echo "Directory $HOME/.bin does not exist. Aborting."
  exit 1
fi
# Check that man page location exists
if [[ ! -d /usr/local/man/ ]]; then
  echo "local man folder does not exist. man not installed"
  $flagMan=1
fi
# If man1 folder does not exist, create it
if [[ ! -d /usr/local/man/man1 ]]; then
  $SUDO mkdir /usr/local/man/man1
fi

# install converter to bin
cp converter $HOME/.bin
# install options.bash to same directory
cp options.bash $HOME/.bin

# create and install the man page if man folder exists
if [ "$flagMan" -ne "1" ]; then
  cd man
  $SUDO /usr/bin/install -g 0 -o 0 -m 0644 converter.1 /usr/local/man/man1/
  $SUDO gzip -f /usr/local/man/man1/converter.1
fi
