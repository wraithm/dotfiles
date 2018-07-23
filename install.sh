#!/bin/bash

linux_pkgs=(zsh vim ghc psql hg git irc mutt term xmonad conky)
macos_pkgs=(zsh vim ghc psql hg)

if [[ "$1" == "linux" ]]; then
    pkgs="${linux_pkgs[@]}"
else
    pkgs="${macos_pkgs[@]}"
fi

stow --no-folding $pkgs
