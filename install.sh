#!/bin/sh

if ! command -v stow &> /dev/null
then
    echo "stow required to install dotfiles"
    exit
fi

stow -vR */
