# Maintainer: Mark Anthony Tantongco
pkgname=68proxy
pkgver=1.1.0
pkgrel=1
pkgdesc="Local reverse proxy + protocol gateway - OpenAI/Anthropic -> Command Code - Omarchy Linux build (English)"
arch=('x86_64' 'aarch64')
url="https://github.com/evanfu0110/68proxy"
license=('MIT')
depends=('webkit2gtk-4.1' 'gtk3' 'libsoup3' 'librsvg' 'libayatana-appindicator' 'hicolor-icon-theme' 'openssl')
makedepends=('rust' 'cargo' 'nodejs' 'npm' 'pnpm')
optdepends=('xdg-utils: open config folder')
source=("$pkgname-$pkgver.tar.gz::https://github.com/evanfu0110/68proxy/archive/refs/tags/v$pkgver.tar.gz"
        "68proxy.desktop")
sha256sums=('SKIP' 'SKIP')

prepare() {
  cd "$pkgname-$pkgver"
  # English default patch - if i18n files exist
  if grep -r "zh-CN" src/ 2>/dev/null | head -n1; then
    echo "Patching default locale to en..."
    find src -type f -name "*.ts" -o -name "*.tsx" | xargs sed -i "s/'zh-CN'/'en'/g; s/"zh-CN"/"en"/g; s/'zh'/'en'/g; s/"zh"/"en"/g" 2>/dev/null || true
  fi
}

build() {
  cd "$pkgname-$pkgver"
  export CARGO_HOME="$srcdir/cargo-home"
  mkdir -p "$CARGO_HOME"
  pnpm install --frozen-lockfile
  pnpm build
  pnpm tauri build --bundles deb,appimage
}

package() {
  cd "$pkgname-$pkgver"
  install -Dm755 "src-tauri/target/release/68proxy" "$pkgdir/usr/bin/68proxy"
  install -Dm644 "$srcdir/68proxy.desktop" "$pkgdir/usr/share/applications/68proxy.desktop"
  if [ -f "src-tauri/icons/128x128.png" ]; then
    install -Dm644 "src-tauri/icons/128x128.png" "$pkgdir/usr/share/icons/hicolor/128x128/apps/68proxy.png"
    install -Dm644 "src-tauri/icons/32x32.png" "$pkgdir/usr/share/icons/hicolor/32x32/apps/68proxy.png"
  fi
  install -Dm644 "LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
