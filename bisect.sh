#!/bin/sh

# We rebuild nixos
NIX_PATH="nixpkgs=$(pwd)/nixpkgs" nixos-rebuild switch

# Then we run the script
# It returns with `2` if it reproduces the issue
luajit debug.lua

