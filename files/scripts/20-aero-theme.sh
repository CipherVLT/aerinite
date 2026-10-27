#!/usr/bin/env bash
# Install the Windows 7 look:
#   - Xfseven (GTK3): apps, menus and the taskbar
#       https://github.com/dubsteptwo/xfseven  (GPL-3.0; based on B00merang Windows-7)
#   - Aero Glass (xfwm4 only): window borders and title bars
#       https://github.com/xRUS47x/Aero-Glass-XFCE4  (CC0 for original material)
# Both upstreams are archived or paused, so we pin commits and treat them as vendored.
set -oeux pipefail

XFSEVEN_REPO="dubsteptwo/xfseven"
XFSEVEN_COMMIT="9a6888654ce0ce78a074bf7b73d5baf5081bce19"   # bump deliberately, never "main"

AERO_REPO="xRUS47x/Aero-Glass-XFCE4"
AERO_COMMIT="62113639be0feb8b22a31515a469bb657d783641"

# Aero Glass ships its border tint as a #FF0000 placeholder that its colour tool is
# meant to replace. We apply its "Sky" preset (Windows 7's default glass colour) here.
GLASS_TINT="#C4DEF9"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

fetch() {  # fetch <owner/repo> <commit> <dest-dir>
  curl -fsSL "https://codeload.github.com/$1/tar.gz/$2" -o "$workdir/src.tar.gz"
  mkdir -p "$3"
  tar -xzf "$workdir/src.tar.gz" -C "$3" --strip-components=1
  rm -f "$workdir/src.tar.gz"
}

# --- Xfseven: GTK theme -------------------------------------------------------
# Only the theme itself; its sample panel config is known to break installs.
fetch "$XFSEVEN_REPO" "$XFSEVEN_COMMIT" "$workdir/xfseven"
install -d /usr/share/themes/Xfseven
cp -a "$workdir/xfseven/xfseven-gtk/." /usr/share/themes/Xfseven/
sed -i 's/^Name=.*/Name=Xfseven/' /usr/share/themes/Xfseven/index.theme
install -Dm0644 "$workdir/xfseven/LICENSE" /usr/share/licenses/xfseven/LICENSE

# --- Aero Glass: window borders only, tinted Sky blue --------------------------
fetch "$AERO_REPO" "$AERO_COMMIT" "$workdir/aero"
install -d /usr/share/themes/Aero-Glass
cp -a "$workdir/aero/xfwm4" /usr/share/themes/Aero-Glass/
sed -i "s/#ff0000/${GLASS_TINT}/Ig" /usr/share/themes/Aero-Glass/xfwm4/*.xpm
install -Dm0644 "$workdir/aero/LICENSE" /usr/share/licenses/aero-glass-xfce4/LICENSE

# --- Checks -------------------------------------------------------------------
test -f /usr/share/themes/Xfseven/gtk-3.0/gtk.css
test -f /usr/share/themes/Aero-Glass/xfwm4/themerc
if grep -qi '#ff0000' /usr/share/themes/Aero-Glass/xfwm4/*.xpm; then
  echo "Window borders still contain the red placeholder"; exit 1
fi
echo "Windows 7 themes installed"
