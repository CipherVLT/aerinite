#!/usr/bin/env bash
# Fail the build early if anything the desktop depends on is missing.
set -euo pipefail

packages=(picom xfburn system-config-printer xfce4-whiskermenu-plugin xfce4-docklike-plugin xfce4-pulseaudio-plugin pipewire)
missing=()
for pkg in "${packages[@]}"; do
  rpm -q --quiet "$pkg" || missing+=("$pkg")
done
if ((${#missing[@]})); then
  echo "Missing packages: ${missing[*]}"
  exit 1
fi

for f in \
  /usr/share/themes/Aero-Glass/gtk-3.0/gtk.css \
  /usr/share/themes/Aero-Glass/xfwm4/themerc \
  /etc/xdg/picom/aero.conf \
  /etc/xdg/picom/basic.conf \
  /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml \
  /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml \
  /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml \
  /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml \
  /etc/xdg/xfce4/panel/default.xml \
  /etc/xdg/xfce4/panel/docklike.rc ; do
  [[ -e "$f" ]] || { echo "Missing $f"; exit 1; }
done
echo "sanity ok"
