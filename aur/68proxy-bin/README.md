# 68proxy-bin - Omarchy Linux (Prebuilt Binary)

Fast install variant - no need to compile Rust (saves ~10 min and 2GB).

## Difference vs 68proxy

- `68proxy` - builds from source (PKGBUILD does `pnpm install && cargo build`). Takes 5-15 min first time.
- `68proxy-bin` - downloads prebuilt binary from GitHub Releases (built by GitHub Actions). Installs in 5 seconds.

Both provide same binary, same Walker entry, same config path.

## Install

yay -S 68proxy-bin

or for source build:

yay -S 68proxy

## How it works

PKGBUILD-bin downloads:

https://github.com/marktantongco/68proxy-omarchy/releases/download/v1.1.0/68proxy

This binary is produced automatically by `.github/workflows/build-omarchy.yml` when you push a tag:

git tag v1.1.0
git push origin v1.1.0

GitHub Actions builds deb, AppImage, and raw binary, then attaches to Release.

Replace marktantongco in PKGBUILD with your GitHub username before pushing to AUR.

## AUR Push

cd aur/68proxy-bin
makepkg --printsrcinfo > .SRCINFO
git clone ssh://aur@aur.archlinux.org/68proxy-bin.git /tmp/aur-bin
cp PKGBUILD .SRCINFO 68proxy.desktop /tmp/aur-bin/
cd /tmp/aur-bin
git add .
git commit -m "Update to 1.1.0"
git push
