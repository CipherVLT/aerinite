#!/usr/bin/env bash
# Windows 7-style shell defaults: theme, keyboard shortcuts, desktop icons, taskbar.
# These are system defaults; anything a user changes in Settings still wins.
set -oeux pipefail

here="$(cd "$(dirname "$0")" && pwd)"
set_xfconf() { python3 "$here/aerinite-xfconf.py" "$@"; }

# --- Look -------------------------------------------------------------------
set_xfconf xsettings string Xfseven           Net ThemeName
set_xfconf xsettings bool   true              Net EnableEventSounds
set_xfconf xsettings string "Noto Sans 9"     Gtk FontName
set_xfconf xsettings bool   true              Gtk ButtonImages
set_xfconf xsettings bool   true              Gtk MenuImages
# Icon theme is left as Fedora's default for now.

# --- Keyboard: the Windows 7 shortcuts Xfce doesn't already have ---------------
# (Xfce already maps Win+E files, Win+D desktop, Win+L lock, Win+R run.)
KB=xfce4-keyboard-shortcuts
set_xfconf $KB string xfce4-popup-whiskermenu commands default Super_L     # tap Win = Start menu
set_xfconf $KB string tile_left_key           xfwm4 default "<Super>Left"   # snap left
set_xfconf $KB string tile_right_key          xfwm4 default "<Super>Right"  # snap right
set_xfconf $KB string maximize_window_key     xfwm4 default "<Super>Up"     # maximise
set_xfconf $KB string hide_window_key         xfwm4 default "<Super>Down"   # minimise

# --- Desktop: only the Recycle Bin (Trash) and drives, like a fresh Windows 7 ----
DT=xfce4-desktop
set_xfconf $DT bool false desktop-icons file-icons show-home
set_xfconf $DT bool false desktop-icons file-icons show-filesystem
set_xfconf $DT bool true  desktop-icons file-icons show-trash
set_xfconf $DT bool true  desktop-icons file-icons show-removable

# --- Taskbar ---------------------------------------------------------------
# Xfce reads the panel layout from xfconf, and falls back to panel/default.xml on
# first login. Ship the same layout in both places so either path gives the Win7 bar.
R="${AERINITE_ROOT:-}"   # empty in real builds; set only for local testing
install -Dm0644 "$R/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" \
  "$R/etc/xdg/xfce4/panel/default.xml"

echo "Windows 7 shell defaults applied"
