#!/usr/bin/env python3
"""Set values in Xfce's system-wide default settings without replacing the whole file.

Fedora ships its own defaults in /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/. Editing them
in place keeps Fedora's other defaults and only changes what Aerinite needs.

Usage (from a build script):
    aerinite-xfconf.py CHANNEL TYPE VALUE PROP [PROP ...]
    e.g. aerinite-xfconf.py xsettings string Aero-Glass Net ThemeName

PROP is the property path, one argument per level, because shortcut names such as
"<Super>Left" may contain characters that are awkward in a single slash-separated path.
Set AERINITE_ROOT to test against a directory other than /.
"""
import os
import sys
import xml.etree.ElementTree as ET

ROOT = os.environ.get("AERINITE_ROOT", "/")
XFCONF_DIR = os.path.join(ROOT, "etc/xdg/xfce4/xfconf/xfce-perchannel-xml")
TYPES = {"string", "bool", "int", "uint", "double"}


def main(argv):
    if len(argv) < 5:
        sys.exit(__doc__)
    channel, vtype, value, *path = argv[1:]
    if vtype not in TYPES:
        sys.exit(f"unsupported type {vtype}")

    os.makedirs(XFCONF_DIR, exist_ok=True)
    fname = os.path.join(XFCONF_DIR, f"{channel}.xml")
    if os.path.exists(fname):
        tree = ET.parse(fname)
        node = tree.getroot()
    else:
        node = ET.Element("channel", name=channel, version="1.0")
        tree = ET.ElementTree(node)

    for i, name in enumerate(path):
        child = next((c for c in node.findall("property") if c.get("name") == name), None)
        last = i == len(path) - 1
        if child is None:
            child = ET.SubElement(node, "property", name=name, type="empty")
        if last:
            child.set("type", vtype)
            child.set("value", value)
        elif child.get("type") != "empty":
            child.set("type", "empty")
            child.attrib.pop("value", None)
        node = child

    ET.indent(tree, space="  ")
    tree.write(fname, encoding="UTF-8", xml_declaration=True)


if __name__ == "__main__":
    main(sys.argv)
