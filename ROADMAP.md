# Roadmap

Target hardware: low-end laptops, e.g. AMD A6 "Stoney Ridge" APUs (2 cores, Radeon R4/R5, 4 GB RAM).

## Phase 1 — Repo up and building
- [x] Fork `winblues/vauxite` → `CipherVLT/aerinite` (2026-10-23). Aerinite files added beside Vauxite's.
- [ ] Set repo description + topics (`bluebuild fedora-atomic xfce aero frutiger-aero windows-7 bootc atomic`).
- [ ] Enable Actions on the fork (Actions tab → "I understand…"); GitHub disables them on new forks.
- [ ] `cosign generate-key-pair` → add `cosign.key` as repo secret `SIGNING_SECRET`, and **replace** `cosign.pub` (the current one is winblues' key, so signature checks would fail against our images).
- [ ] Settings → Actions → General → Workflow permissions: "Read and write" so the build can push to ghcr.io.
- [ ] After first build: make the `aerinite` package public in GitHub → Packages so `bootc switch` can pull it.
- [ ] Run the workflow; fix whatever the first build breaks.
- [ ] Verify ujust picks up `60-custom.just` (run `ujust --list`). If not, check how the base image's ublue-os-just imports custom files and rename to match.
- [x] Checked that picom, xfce4-whiskermenu-plugin and xfburn are all in Fedora 44.
- [ ] Build an installer: Actions tab → "Build installer ISO" → Run workflow. The ISO appears under the run's Artifacts.

## Phase 2 — Test in a VM first (download the ISO from Actions, or `just aerinite-iso`, then `just aerinite-vm`)
- [ ] VM at 2 cores / 4 GB to mimic low-end hardware. In a VM the glass starts in "basic" mode automatically (no 3D acceleration); try `ujust aero-glass on` only if the VM has 3D enabled.
- [ ] Window borders are Sky blue (not red); taskbar is dark smoked glass; apps use the Xfseven theme.
- [ ] Does picom start? Glass visible on titlebars, panel, whisker menu?
- [ ] Does xfwm4 compositor stay off (no double shadows)?
- [ ] Shortcuts: tap Win opens Start; Win+Left/Right snap; Win+Up maximise; Win+Down minimise; Win+E/D/L/R.
- [ ] Taskbar: Start orb, Firefox and Files pinned, open windows show their names, clock shows time over date.
- [ ] Start menu: apps on the left, categories on the right, search and power buttons at the bottom.
- [ ] Desktop: My Computer and Trash icons; My Computer opens to the drives.
- [ ] On real hardware: burn a test audio CD and data CD in Xfburn; print a test page.
- [ ] Panel defaults load for a **new** user account (xfconf system defaults only apply when the user has no config yet).

## Phase 3 — Look & feel polish
- [ ] Icon theme: chosen by hand after install (licensing).
- [ ] Wallpaper: original Frutiger-Aero wallpaper (bubbles, grass, sky) — commission or make one; don't ship Microsoft's.
- [ ] Font: Noto Sans 9 now; try **Selawik** (Microsoft's open-source Segoe UI metric-compatible font, OFL) for a closer feel.
- [ ] LightDM greeter: Aero-styled background + theme via `lightdm-gtk-greeter.conf`.
- [ ] Plymouth boot splash with the orb.
- [ ] Sounds: original startup/notification sounds (no Win7 .wavs).
- [ ] Optional: skippy-xd as a "Flip 3D"-ish window switcher (Vauxite full ships it).

## Phase 4 — Performance tuning on the real hardware
- [ ] Compare `ujust aero-glass on` vs `basic`: watch `top` for picom CPU and feel window drags.
- [ ] If blur stutters, try `blur-strength = 1`, or default the image to `basic` and let users opt in.
- [ ] Confirm Firefox (Flatpak) is usable on 4 GB; zram is on by default in Fedora.
- [ ] Battery life check with picom on vs off.

## Later / maybe
- [ ] Permanent ISO hosting (right now ISOs are kept for 7 days on each Actions run).
- [ ] Pull upstream Vauxite changes now and then (GitHub "Sync fork" button); our files are separate, so only README, justfile, build.yml and AGENTS.md can conflict.
- [ ] `aerinite-basic` variant that defaults to no blur for even weaker machines.
- [ ] Optional printer drivers beyond Gutenprint (e.g. `brlaser`, `epson-inkjet-printer-escpr`).
- [ ] Contribute fixes back to Aero-Glass-XFCE4 forks since upstream is paused.

## Decision log
- **2026-10-23** — Forked Vauxite as `CipherVLT/aerinite` for credit + history; Aerinite still builds *on top of* the published `vauxite-minimal` image rather than rebuilding it.
- **2026-10-23** — fastfetch logo is an original glass orb, not the Windows flag, to keep the public repo clear of Microsoft trademarks (same stance as the Aero theme's own notice).
