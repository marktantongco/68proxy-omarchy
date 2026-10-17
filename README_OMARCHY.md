# 68proxy — Omarchy Linux (English Build)

> Plug-and-play local **reverse proxy + protocol gateway** that translates OpenAI / Anthropic APIs to Command Code's private API.

**Original:** https://github.com/evanfu0110/68proxy (Chinese, Windows-only builds)
**This Fork:** Rebuilt, converted and translated to **Omarchy Linux native app** (Arch + Hyprland + Walker)

---

## What is 68proxy?

- Exposes OpenAI `/v1/chat/completions` and Anthropic `/v1/messages` compatible endpoints
- Also `/v1/models` and `/health`
- Converts requests to Command Code CLI envelope: system prompts, multi-turn, tool calls, multimodal images, tool_choice
- Forwards to `/alpha/generate` with anti-detection: per-key sessions, device fingerprints, traceparent, fake project slug, dynamic CC version
- Streaming translation: upstream NDJSON → OpenAI / Anthropic SSE or non-stream JSON
- UI: Console (live relay rail), Relay Records (time/model/path/status), Models (30 built-ins fallback), Tool Integration (auto prompt for Cursor/OpenCode/Cherry Studio), Debug Logs (ring buffer), Settings (port/address, auto-run, tray), System Tray

---

## Omarchy Changes

1. **English First:** default locale `en`, README translated, UI strings default to English
2. **Linux Bundle:** Tauri config now builds `deb` + `appimage` + raw binary, not NSIS .exe
3. **Arch Deps:** `webkit2gtk-4.1`, `gtk3`, `libsoup3`, `librsvg`, `libayatana-appindicator`, `javascriptcoregtk4.1`
4. **XDG Paths:** Config moved to `~/.config/68proxy/config.json` (was Windows AppData)
5. **Omarchy App Convention:** 
   - App lives in `~/.local/share/68proxy/`
   - Binary symlinked to `~/.local/bin/68proxy`
   - Desktop entry in `~/.local/share/applications/68proxy.desktop` → appears in Walker (Super+Space)
6. **Hyprland Rules:** opacity + floating rules included
7. **PKGBUILD:** ready for AUR / `makepkg -si` or `yay`

---

## Quick Install (Omarchy)

```bash
# 1. Dependencies
sudo pacman -S --needed base-devel rust cargo nodejs npm pnpm webkit2gtk-4.1 gtk3 libsoup3 librsvg libayatana-appindicator javascriptcoregtk-4.1

# 2. Clone this fork
git clone <your-fork-url> ~/Apps/68proxy-omarchy
cd ~/Apps/68proxy-omarchy

# 3. Install (Omarchy style)
chmod +x omarchy/install.sh
./omarchy/install.sh

# 4. Run
68proxy
# or Super+Space -> 68proxy
```

Test health:
```bash
curl http://127.0.0.1:3050/health
```

Configure any OpenAI client:
```
Base URL: http://127.0.0.1:3050/v1
Anthropic Base URL: http://127.0.0.1:3050
API Key: sk-placeholder (real key stored locally in ~/.config/68proxy/config.json)
Model: deepseek/deepseek-v4-flash
```

---

## Build from Source (Manual)

```bash
git clone https://github.com/evanfu0110/68proxy
cd 68proxy
# apply patches from this repo:
cp omarchy/tauri.conf.json src-tauri/tauri.conf.json
pnpm install
pnpm build
pnpm tauri dev      # dev
pnpm tauri build    # release -> src-tauri/target/release/68proxy and bundle/deb/
```

---

## Files in this kit

- `PKGBUILD` - Arch/Omarchy package
- `68proxy.desktop` - Walker launcher
- `omarchy/install.sh` - Omarchy-style installer
- `omarchy/tauri.conf.json` - Linux bundle config
- `omarchy/hyprland.conf` - Optional Hyprland rules
- `README_OMARCHY.md` - This file

## License
MIT © 6ix8ight (original), Omarchy port MIT
