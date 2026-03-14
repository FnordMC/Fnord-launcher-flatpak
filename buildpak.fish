#!/bin/env fish
# Copyright illy 2025-2026 - Licensed under Unlicense
# https://unlicense.org/
# just to script to help me not have to ctrl + r the command lol
echo this flatpak is for building and packaging the launcher
set APPID xyz.fnordmc.FnordLauncher
set MANIFEST xyz.fnordmc.FnordLauncher.yml
set _flatpak_opts --install-deps-from=flathub --force-clean .build --repo=.repo --ccache $MANIFEST

argparse -x 'user,clean' 'u/user' 'c/clean' -- $argv

if test -n "$_flag_c"
  rm .repo
  exit
end

if test -n "$_flag_u"
  set -a _flatpak_opts --user
end

if command -v flatpak-builder
  set FPBUILD (command -v flatpak-builder)
else
  set FPBUILD flatpak run org.flatpak.Builder
end

$FPBUILD $_flatpak_opts || exit
set filename_to_use \
  (basename -s .tar.gz (grep -o 'FnordLauncher-[^\"]*.tar.gz' $MANIFEST)).flatpak
flatpak build-bundle .repo $filename_to_use $APPID
