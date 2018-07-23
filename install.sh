#!/bin/bash

linux_pkgs=(conky  ghc  git  hg  irc  mutt  term  vim  xmonad  zsh psql)
macos_pkgs=(ghc  hg  vim  zsh psql)

if [[ "$1" == "linux" ]]; then
    pkgs="${linux_pkgs[@]}"
else
    pkgs="${macos_pkgs[@]}"
fi

stow $pkgs
