#!/usr/bin/env bash
set -e
# 68proxy - Omarchy Linux Installer
# Follows Omarchy convention: apps live in ~/.local/share or ~/Apps

APP_NAME="68proxy"
SRC_REPO="https://github.com/evanfu0110/68proxy"
APP_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/68proxy"
SRC_DIR="$APP_ROOT/src"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_ROOT="$HOME/.local/share/icons/hicolor"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${GREEN}==> 68proxy - Omarchy Linux Installer (English)${NC}"
echo "    App root: $APP_ROOT"

# Deps check
echo -e "${YELLOW}[*] Checking dependencies...${NC}"
MISSING=()
command -v cargo >/dev/null || MISSING+=("rust")
command -v node >/dev/null || MISSING+=("nodejs")
command -v pnpm >/dev/null || MISSING+=("pnpm")
if [ ${#MISSING[@]} -ne 0 ]; then
  echo -e "${RED}Missing: ${MISSING[*]}${NC}"
  echo "Run: sudo pacman -S --needed base-devel rust cargo nodejs npm pnpm webkit2gtk-4.1 gtk3 libsoup3 librsvg libayatana-appindicator javascriptcoregtk-4.1"
  exit 1
fi

mkdir -p "$APP_ROOT" "$BIN_DIR" "$DESKTOP_DIR"

# Clone or update
if [ -d "$SRC_DIR/.git" ]; then
  echo -e "${YELLOW}[*] Updating existing clone...${NC}"
  cd "$SRC_DIR"
  git pull --ff-only || true
else
  echo -e "${YELLOW}[*] Cloning 68proxy...${NC}"
  git clone "$SRC_REPO" "$SRC_DIR"
  cd "$SRC_DIR"
fi

# Apply Omarchy patches if present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/patches" ]; then
  echo -e "${YELLOW}[*] Applying Omarchy patches...${NC}"
  cp -f "$SCRIPT_DIR/tauri.conf.json" src-tauri/tauri.conf.json 2>/dev/null || true
  cp -f "$SCRIPT_DIR/68proxy.desktop" ./68proxy.desktop 2>/dev/null || true
fi

# English patch
echo -e "${YELLOW}[*] Setting English default...${NC}"
# Try to patch common i18n files, safe no-op if not found
find src -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" \) -exec sed -i "s/default.*['\"]zh-CN['\"]/default: 'en'/g; s/default.*['\"]zh['\"]/default: 'en'/g; s/locale.*=.*['\"]zh-CN['\"]/locale = 'en'/g" {} \; 2>/dev/null || true

echo -e "${YELLOW}[*] Installing frontend deps (pnpm install)...${NC}"
pnpm install

echo -e "${YELLOW}[*] Building frontend + Tauri (this takes ~2-4 min first time)...${NC}"
pnpm build
pnpm tauri build

echo -e "${YELLOW}[*] Installing binary...${NC}"
cp "src-tauri/target/release/68proxy" "$APP_ROOT/68proxy"
ln -sf "$APP_ROOT/68proxy" "$BIN_DIR/68proxy"
chmod +x "$APP_ROOT/68proxy"

# Icons
mkdir -p "$ICON_ROOT/128x128/apps" "$ICON_ROOT/32x32/apps"
cp src-tauri/icons/128x128.png "$ICON_ROOT/128x128/apps/68proxy.png" 2>/dev/null || true
cp src-tauri/icons/32x32.png "$ICON_ROOT/32x32/apps/68proxy.png" 2>/dev/null || true

# Desktop entry
echo -e "${YELLOW}[*] Installing desktop entry...${NC}"
cat > "$DESKTOP_DIR/68proxy.desktop" <<EOF
[Desktop Entry]
Name=68proxy
GenericName=Protocol Gateway
Comment=OpenAI/Anthropic compatible gateway for Command Code
Exec=$BIN_DIR/68proxy
Icon=68proxy
Terminal=false
Type=Application
Categories=Development;Network;
StartupWMClass=68proxy
Keywords=proxy;openai;anthropic;gateway;
EOF

update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true

echo ""
echo -e "${GREEN}[✓] 68proxy installed for Omarchy!${NC}"
echo "    Binary:  $BIN_DIR/68proxy"
echo "    Config:  ~/.config/68proxy/config.json"
echo "    Launch:  Super+Space -> type '68proxy' or run '68proxy' in terminal"
echo "    Test:    curl http://127.0.0.1:3050/health"
echo "    OpenAI URL:     http://127.0.0.1:3050/v1"
echo "    Anthropic URL:  http://127.0.0.1:3050"
