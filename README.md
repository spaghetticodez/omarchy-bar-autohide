# Omarchy Bar Autohide

Hides the Omarchy bar until the pointer hits its screen edge.

> [!IMPORTANT]
> Omarchy 4 Quickshell bar. Not for older Waybar releases.

## Behavior

- Hides the bar when the plugin loads.
- Reveals it when the pointer reaches the bar's screen edge.
- Hides it again one second after the pointer leaves the bar.
- A manual show stays up until the edge is used.
- Works on any screen edge, and on more than one monitor.
- Disabling the plugin shows the bar.

The service cannot see the bar's own surface, so while the bar is revealed it checks `hyprctl cursorpos` instead of covering the bar. Clicks still reach the widgets. There is no helper process left running after the bar hides.

## Install

```bash
omarchy plugin add https://github.com/spaghetticodez/omarchy-bar-autohide.git --enable
```

## Update

```bash
omarchy plugin update ericvrp.bar-autohide
```

The installed copy should track this fork. Upstream `ericvrp/omarchy-bar-autohide` is no longer maintained.

## Disable

```bash
omarchy plugin disable ericvrp.bar-autohide
```

## License

[MIT](LICENSE). Provided as is, without warranty.
