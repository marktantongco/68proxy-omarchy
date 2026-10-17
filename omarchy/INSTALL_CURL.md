# One-Liner Install - No yay needed

For Omarchy Linux - installs prebuilt binary from GitHub Releases:

```bash
curl -fsSL https://raw.githubusercontent.com/marktantongco/68proxy-omarchy/main/install.sh | bash
```

With wget:

```bash
wget -qO- https://raw.githubusercontent.com/marktantongco/68proxy-omarchy/main/install.sh | bash
```

What it does:
1. Detects Omarchy / Arch
2. Fetches latest release binary from marktantongco/68proxy-omarchy
3. Installs to ~/.local/bin/68proxy (no sudo)
4. Installs Walker entry to ~/.local/share/applications
5. Sets up ~/.config/68proxy/

Uninstall:
```bash
rm ~/.local/bin/68proxy ~/.local/share/68proxy/68proxy ~/.local/share/applications/68proxy.desktop
```

Replace marktantongco with your GitHub username.
