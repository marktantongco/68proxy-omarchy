#!/usr/bin/env bash
set -e
# Helper to push to AUR
# Usage: ./omarchy/push-aur.sh

if [ ! -f "PKGBUILD" ] || [ ! -f ".SRCINFO" ]; then
  echo "PKGBUILD and .SRCINFO required in root"
  exit 1
fi

echo "[*] Checking PKGBUILD with namcap..."
namcap PKGBUILD || true

echo "[*] Updating .SRCINFO..."
makepkg --printsrcinfo > .SRCINFO
cat .SRCINFO

echo ""
echo "[*] Ready to push to AUR. Steps:"
echo "  1. git clone ssh://aur@aur.archlinux.org/68proxy.git /tmp/aur-68proxy"
echo "  2. cp PKGBUILD .SRCINFO 68proxy.desktop /tmp/aur-68proxy/"
echo "  3. cd /tmp/aur-68proxy && git add . && git commit -m 'Update to 1.1.0-omarchy' && git push"
echo ""
read -p "Do you want to auto-push now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  TMP=$(mktemp -d)
  git clone ssh://aur@aur.archlinux.org/68proxy.git "$TMP"
  cp PKGBUILD .SRCINFO 68proxy.desktop "$TMP"/
  cd "$TMP"
  git add PKGBUILD .SRCINFO 68proxy.desktop
  git commit -m "Update to 1.1.0 Omarchy English build"
  git push
  echo "[✓] Pushed to AUR"
fi
