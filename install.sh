#!/bin/bash

linux_pkgs=(conky  ghc  git  hg  irc  mutt  term  vim  xmonad  zsh)
macos_pkgs=(ghc  git  hg  vim  zsh)

if [[ "$1" == "linux" ]]; then
    pkgs="${linux_pkgs[@]}"
else
    pkgs="${macos_pkgs[@]}"
fi

stow $pkgs
