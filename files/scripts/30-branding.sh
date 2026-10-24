#!/usr/bin/env bash
# Image branding: os-release name, fastfetch, picom autostart.
set -oeux pipefail

IMAGE_PRETTY_NAME="Aerinite"

# Rename in os-release (keeps Fedora ID so tooling still works)
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"${IMAGE_PRETTY_NAME} (Fedora $(rpm -E %fedora))\"/" /usr/lib/os-release
sed -i "s/^NAME=.*/NAME=\"${IMAGE_PRETTY_NAME}\"/" /usr/lib/os-release

# Our fastfetch config replaces Vauxite's default — the file itself is shipped in
# files/system/usr/share/ublue-os/fastfetch.jsonc and overwrites the base image's copy.
test -f /usr/share/ublue-os/aerinite-logo.txt

# xfwm4's own compositor is turned off in our xfconf defaults; picom takes over.
test -f /etc/xdg/autostart/aerinite-picom.desktop
