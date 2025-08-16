#!/usr/bin/env nix-shell
#!nix-shell -i bash -p inotify-tools

set -x

while true; do
  inotifywait -e modify,create,delete -r /etc/nixos/ && \
  echo "Change detected! Running command..."
  # your command here
  cp -r /etc/nixos/* .
done
