# Omarchy autohide

Simple Omarchy 4 plugin. It hides the bar. The screen edge shows it. The pointer leaving hides it again.

Hermes project: **Omarchy autohide plugin** (`omarchy-autohide`). Host admin stays in the Omarchy project. Do not copy monitor, LUKS, or other plugin work here.

## Source

- Repo: `/home/tr4sh/Projects/omarchy-bar-autohide`
- Fork: `https://github.com/spaghetticodez/omarchy-bar-autohide` (`main`)
- Installed copy: `~/.config/omarchy/plugins/ericvrp.bar-autohide`
- Plugin id stays `ericvrp.bar-autohide`. That name is not the update remote.
- Original author: Eric van Riet Paap. Credit him in the README. `ericvrp` is fetch-only.

## Rules

- Edit this repo, push `origin main`, then fast-forward the installed copy.
- Hide and show only through `omarchy-toggle-bar`. `on` hides the bar. `off` shows it.
- A service only gets `barHidden`, `barSize`, and `position`. Do not add hover observers or popout checks.
- Poll `hyprctl cursorpos` only after the pointer leaves the 1px edge, every 200ms. Do not cover the bar.
- README stays plain English.
- Do not edit `/usr/share/omarchy`.

## Check

Same commit on both checkouts. Bar parked off-screen. The 1px trigger is present. No QML error after reload.
