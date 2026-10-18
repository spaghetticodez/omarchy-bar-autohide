# Bar Autohide

Hides the Omarchy bar. Move the pointer to the screen edge and the bar comes back. It hides again one second after the pointer leaves.

This is for Omarchy 4. It does not work with the old Waybar bar.

Original plugin by [Eric van Riet Paap](https://github.com/ericvrp/omarchy-bar-autohide). This fork keeps that work going.

## What it does

- Hides the bar when it starts.
- Shows the bar when the pointer touches the bar's edge.
- Hides the bar again after the pointer leaves.
- If you show the bar yourself, it stays until you use the edge.
- Works on the top, bottom, left, or right edge, and on more than one screen.
- Turning the plugin off shows the bar.

## Install

```bash
omarchy plugin add https://github.com/spaghetticodez/omarchy-bar-autohide.git --enable
```

## Update

```bash
omarchy plugin update ericvrp.bar-autohide
```

Use this fork. The original project is no longer updated.

## Turn off

```bash
omarchy plugin disable ericvrp.bar-autohide
```

## License

[MIT](LICENSE). No warranty.
