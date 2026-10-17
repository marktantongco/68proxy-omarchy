#!/usr/bin/env bash
# Generate .SRCINFO for AUR
makepkg --printsrcinfo > .SRCINFO
cat .SRCINFO
