#!/bin/sh

if ! [ -x "$(command -v stow)" ]
then
    echo "stow required to install dotfiles"
    exit 1
fi

stow -vR */
