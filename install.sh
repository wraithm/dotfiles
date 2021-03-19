#!/bin/bash

linux_pkgs=(zsh vim ghc psql hg git irc mutt term xmonad conky)
macos_pkgs=(zsh vim ghc psql macos)

work_linux_pkgs=(workzsh vim ghc psql workgit gnome)
work_macos_pkgs=(zsh vim ghc psql macos workgit)

case "$1" in
    "linux")
        pkgs="${linux_pkgs[@]}"
        ;;
    "worklinux")
        pkgs="${work_linux_pkgs[@]}"
        ;;
    "macos")
        pkgs="${macos_pkgs[@]}"
        ;;
    "workmacos")
        pkgs="${work_macos_pkgs[@]}"
        ;;
esac

stow --no-folding "$pkgs"
