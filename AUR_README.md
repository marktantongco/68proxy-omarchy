# AUR Package for 68proxy - Omarchy Linux

This is the AUR package for 68proxy Omarchy build.

## Install

yay -S 68proxy

or

git clone https://aur.archlinux.org/68proxy.git
cd 68proxy
makepkg -si

## What this package does

- Clones https://github.com/evanfu0110/68proxy v1.1.0
- Patches default locale to English (Omarchy)
- Builds Tauri Linux binary with webkit2gtk-4.1
- Installs:
  - /usr/bin/68proxy
  - /usr/share/applications/68proxy.desktop (Walker launcher)
  - icons

## After install

Run:

68proxy

or Super+Space -> 68proxy

Config: ~/.config/68proxy/config.json
Health: curl http://127.0.0.1:3050/health

## Maintainer

Mark Anthony Tantongco
