#!/usr/bin/env bash
# Install the Aero-Glass-XFCE4 theme (GTK3 + xfwm4) system-wide.
# Upstream: https://github.com/xRUS47x/Aero-Glass-XFCE4  (CC0 for original material;
# upstream development is paused, so we pin a commit and treat it as vendored).
set -oeux pipefail

AERO_REPO="xRUS47x/Aero-Glass-XFCE4"
AERO_COMMIT="62113639be0feb8b22a31515a469bb657d783641"   # bump deliberately, never "main"

# Optional: B00merang Windows-7 theme, used only as a fallback / reference for
# GTK2 apps and panel spacing. Comment out if you don't need it.
B00M_REPO="B00merang-Project/Windows-7"
B00M_COMMIT="943b5307b349d3526068be0fa32f7549ee37ab45"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

fetch() {  # fetch <owner/repo> <commit> <dest-dir>
  curl -fsSL "https://codeload.github.com/$1/tar.gz/$2" -o "$workdir/src.tar.gz"
  mkdir -p "$3"
  tar -xzf "$workdir/src.tar.gz" -C "$3" --strip-components=1
  rm -f "$workdir/src.tar.gz"
}

# --- Aero Glass (primary) ---
fetch "$AERO_REPO" "$AERO_COMMIT" "$workdir/aero"
install -d /usr/share/themes/Aero-Glass
cp -a "$workdir/aero/gtk-3.0" "$workdir/aero/xfwm4" /usr/share/themes/Aero-Glass/
install -Dm0755 "$workdir/aero/xfce-color-switching-tool.sh" \
  /usr/share/themes/Aero-Glass/xfce-color-switching-tool.sh
install -Dm0644 "$workdir/aero/LICENSE" /usr/share/licenses/aero-glass-xfce4/LICENSE
# NOTE: we ship our own tuned picom.conf in files/system/etc/xdg/picom/, not theirs.

# --- B00merang Windows-7 (fallback) ---
fetch "$B00M_REPO" "$B00M_COMMIT" "$workdir/b00m"
install -d /usr/share/themes/Windows-7-Classic
cp -a "$workdir/b00m/." /usr/share/themes/Windows-7-Classic/
rm -rf /usr/share/themes/Windows-7-Classic/.git*

# Sanity
test -f /usr/share/themes/Aero-Glass/xfwm4/themerc || { echo "xfwm4 theme missing"; exit 1; }
echo "Aero theme installed"
