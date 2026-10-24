# Aerinite

A Windows 7-inspired desktop for Linux, with the glassy Aero look, a classic taskbar and a start button. It's light enough to run well on older laptops.

Aerinite is built on [Vauxite](https://github.com/winblues/vauxite) by [winblues](https://github.com/winblues), which provides the Fedora Xfce base underneath. Thank you to them for the foundation.

> **Status:** early work in progress. Not ready for daily use yet.

## Features

- Glass-style windows, taskbar and start menu
- A taskbar laid out like Windows 7: start button on the left, your apps in the middle, clock and tray on the right
- Drag a window to the edge of the screen to snap it into place
- A simple switch to turn the glass effect off on slower computers
- Updates install automatically in the background, and you can roll back if one ever causes trouble
- CD/DVD burning and printer setup included

## Install

Coming soon. Install instructions will be added once the first version is ready.

## Changing the glass effect

Open a terminal and run one of these:

```bash
ujust aero-glass on      # full glass effect
ujust aero-glass basic   # lighter, no blur (better for older computers)
ujust aero-glass off     # no effects at all
```

## Credits

- [Vauxite](https://github.com/winblues/vauxite) by winblues, the base this project is built on
- [Aero-Glass-XFCE4](https://github.com/xRUS47x/Aero-Glass-XFCE4) by xRUS47x, the glass theme
- [Windows-7](https://github.com/B00merang-Project/Windows-7) by the B00merang Project, the backup theme
- [Fedora](https://fedoraproject.org), [Universal Blue](https://universal-blue.org) and the [Xfce](https://www.xfce.org) team

## License

Apache-2.0, the same as Vauxite.

Microsoft, Windows and Windows 7 are trademarks of Microsoft Corporation. This project is not affiliated with or endorsed by Microsoft, and it does not include any Microsoft software, logos, fonts or wallpapers.
