# Aerinite ujust recipes  (run: ujust aero-glass on)

# Toggle Aero glass blur: on | basic | off
aero-glass state="on":
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/aerinite"
    case "{{ state }}" in
      on|aero) p=aero ;;
      basic)   p=basic ;;
      off)     p=off ;;
      *) echo "usage: ujust aero-glass [on|basic|off]"; exit 1 ;;
    esac
    echo "$p" > "${XDG_CONFIG_HOME:-$HOME/.config}/aerinite/picom-profile"
    pkill -x picom || true
    nohup /usr/libexec/aerinite-picom >/dev/null 2>&1 &
    echo "Aero glass: $p"

# Change the glass tint colour (wraps the theme's own tool)
aero-color:
    /usr/share/themes/Aero-Glass/xfce-color-switching-tool.sh

# Reset panel + theme to Aerinite defaults (keeps your files)
aero-reset-desktop:
    #!/usr/bin/env bash
    set -euo pipefail
    pkill -x xfconfd || true
    for ch in xsettings xfwm4 xfce4-panel; do
      rm -f "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/$ch.xml"
    done
    echo "Log out and back in to load the defaults."
