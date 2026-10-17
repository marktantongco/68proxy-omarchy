#!/usr/bin/env bash
# 68proxy - Omarchy One-Liner Installer
# curl -fsSL https://raw.githubusercontent.com/marktantongco/68proxy-omarchy/main/install.sh | bash
set -e

REPO="marktantongco/68proxy-omarchy"
BINARY_NAME="68proxy"
VERSION="latest"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}"
echo "  ____  ___  ____  ____   ___  __  __   __"
echo " |___ \( _ )|  _ \|  _ \ / _ \ \ \/ / \ \ / /"
echo "   __) / _ \| |_) | |_) | | | | \  /   \ V / "
echo "  / __/ (_) |  __/|  _ <  | |_| | /  \    | |  "
echo " |_____\___/|_|   |_| \_\ \___/ /_/\_\   |_|  "
echo -e "${NC}"
echo -e "${GREEN}Omarchy Linux One-Liner Installer${NC}"
echo ""

ARCH=$(uname -m)
case $ARCH in
  x86_64) ARCH_DEB="amd64" ;;
  aarch64|arm64) ARCH_DEB="arm64" ;;
  *) echo -e "${RED}Unsupported arch: $ARCH${NC}"; exit 1 ;;
esac

if grep -q "Omarchy" /etc/os-release 2>/dev/null || [ -f "$HOME/.config/omarchy" ] || [ -d "$HOME/.config/hypr" ]; then
  echo -e "${GREEN}✓ Detected Omarchy / Arch Linux${NC}"
else
  echo -e "${YELLOW}⚠ Not Omarchy, but will try Arch-compatible install${NC}"
fi

INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/68proxy"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/128x128/apps"
CONFIG_DIR="$HOME/.config/68proxy"

mkdir -p "$INSTALL_DIR" "$BIN_DIR" "$DESKTOP_DIR" "$ICON_DIR" "$CONFIG_DIR"

if [ "$VERSION" = "latest" ]; then
  echo -e "${YELLOW}[*] Fetching latest release for $REPO...${NC}"
  LATEST_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | grep -o '"tag_name": "[^"]*"' | head -1 | cut -d'"' -f4 || true)
  if [ -z "$LATEST_URL" ]; then
    LATEST_URL="v1.1.0"
    echo -e "${YELLOW}  Could not fetch API, using $LATEST_URL${NC}"
  else
    echo -e "${GREEN}  Latest: $LATEST_URL${NC}"
    VERSION=$LATEST_URL
  fi
fi

TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT
DOWNLOAD_SUCCESS=0

BINARY_URL="https://github.com/$REPO/releases/download/${VERSION}/68proxy"
echo -e "${YELLOW}[*] Trying $BINARY_URL...${NC}"
if curl -fL -o "$TMP/68proxy" "$BINARY_URL" 2>/dev/null; then
  echo -e "${GREEN}  ✓ Got binary${NC}"
  DOWNLOAD_SUCCESS=1
else
  echo -e "${YELLOW}  Binary not found, trying AppImage...${NC}"
  APPIMAGE_URL="https://github.com/$REPO/releases/download/${VERSION}/68proxy_${VERSION#v}_amd64.AppImage"
  if curl -fL -o "$TMP/68proxy.AppImage" "$APPIMAGE_URL" 2>/dev/null; then
    echo -e "${GREEN}  ✓ Got AppImage${NC}"
    chmod +x "$TMP/68proxy.AppImage"
    cp "$TMP/68proxy.AppImage" "$TMP/68proxy"
    DOWNLOAD_SUCCESS=1
  fi
fi

if [ $DOWNLOAD_SUCCESS -eq 0 ]; then
  echo -e "${YELLOW}[*] No prebuilt binary found. Falling back to source build...${NC}"
  if ! command -v pnpm &>/dev/null || ! command -v cargo &>/dev/null; then
    echo -e "${RED}  Missing build deps. Install:${NC}"
    echo "  sudo pacman -S --needed base-devel rust cargo nodejs npm pnpm webkit2gtk-4.1 gtk3 libsoup3"
    exit 1
  fi
  SRC_DIR="$INSTALL_DIR/src"
  if [ ! -d "$SRC_DIR/.git" ]; then
    git clone https://github.com/evanfu0110/68proxy "$SRC_DIR"
  fi
  cd "$SRC_DIR"
  pnpm install
  pnpm build
  pnpm tauri build
  cp src-tauri/target/release/68proxy "$TMP/68proxy"
  DOWNLOAD_SUCCESS=1
fi

echo -e "${YELLOW}[*] Installing to $BIN_DIR/$BINARY_NAME...${NC}"
cp "$TMP/68proxy" "$INSTALL_DIR/68proxy"
chmod +x "$INSTALL_DIR/68proxy"
ln -sf "$INSTALL_DIR/68proxy" "$BIN_DIR/68proxy"

echo -e "${YELLOW}[*] Installing desktop entry (Walker)...${NC}"
cat > "$DESKTOP_DIR/68proxy.desktop" <<EOF
[Desktop Entry]
Name=68proxy
GenericName=Protocol Gateway
Comment=OpenAI/Anthropic compatible gateway for Command Code - Omarchy Build
Exec=$BIN_DIR/68proxy
Icon=68proxy
Terminal=false
Type=Application
Categories=Development;Network;Utility;
StartupWMClass=68proxy
Keywords=proxy;openai;anthropic;llm;gateway;omarchy;
EOF

echo -e "${YELLOW}[*] Installing icon...${NC}"
curl -fsSL -o "$ICON_DIR/68proxy.png" "https://raw.githubusercontent.com/evanfu0110/68proxy/main/src-tauri/icons/128x128.png" 2>/dev/null || true
update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}[✓] 68proxy installed!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "  Binary:  $BIN_DIR/68proxy"
echo "  Config:  $CONFIG_DIR/config.json"
echo "  Launch:  Super+Space → 68proxy"
echo "  Or:      68proxy"
echo ""
echo "  Test:    curl http://127.0.0.1:3050/health"
echo "  OpenAI:  http://127.0.0.1:3050/v1"
echo "  Anthropic: http://127.0.0.1:3050"
echo ""
echo -e "${YELLOW}  First run will ask for API Key (stored in $CONFIG_DIR/config.json)${NC}"
