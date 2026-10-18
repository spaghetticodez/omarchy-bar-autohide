import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs.Commons

// Hide the bar. A one-pixel edge reveals it; the pointer leaving that band hides it again.
// Third-party services only get barHidden, barSize, and position, so leave-detection
// is a cursor poll after the pointer leaves the edge. The poll does not cover the bar, so clicks still land.
Item {
  id: root

  readonly property int revealThickness: 1
  readonly property int hideDelayMs: 1000

  property var shell: null
  property bool autoRevealed: false
  property bool edgeHovered: false
  property bool pointerInBarBand: false

  readonly property var bar: shell ? shell.bar : null
  readonly property string position: bar && bar.position ? bar.position : "top"
  readonly property bool vertical: position === "left" || position === "right"
  readonly property bool barHidden: !!(bar && bar.barHidden)
  readonly property bool holding: edgeHovered || pointerInBarBand

  function setHidden(hidden) {
    // `on` creates the bar-off flag, which hides the bar. The command also
    // asks the shell to re-read the flag; a raw touch can be missed.
    Util.execArgv(["omarchy-toggle-bar", hidden ? "on" : "off"])
  }

  function hideBar() {
    if (!autoRevealed || barHidden || holding) return
    autoRevealed = false
    pointerInBarBand = false
    setHidden(true)
  }

  function showBar() {
    if (!barHidden) {
      autoRevealed = true
      return
    }
    autoRevealed = true
    setHidden(false)
  }

  function cursorInBarBand(px, py) {
    const size = Math.max(1, (bar && bar.barSize) || 30)
    const screens = Quickshell.screens || []
    for (let i = 0; i < screens.length; ++i) {
      const s = screens[i]
      if (!s) continue
      const sx = Number(s.x || 0)
      const sy = Number(s.y || 0)
      const sw = Number(s.width || 0)
      const sh = Number(s.height || 0)
      if (sw <= 0 || sh <= 0) continue
      if (px < sx || px >= sx + sw || py < sy || py >= sy + sh) continue
      if (position === "top") return py < sy + size
      if (position === "bottom") return py >= sy + sh - size
      if (position === "left") return px < sx + size
      if (position === "right") return px >= sx + sw - size
    }
    return false
  }

  Process {
    id: cursorProbe

    running: false
    command: ["hyprctl", "cursorpos"]
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = String(this.text || "").trim().split(",")
        if (parts.length < 2) return
        root.pointerInBarBand = root.cursorInBarBand(Number(parts[0]), Number(parts[1]))
      }
    }
  }

  Timer {
    interval: 200
    repeat: true
    running: root.autoRevealed && !root.barHidden && !root.edgeHovered
    onTriggered: if (!cursorProbe.running) cursorProbe.running = true
    onRunningChanged: if (!running) root.pointerInBarBand = false
  }

  Timer {
    interval: root.hideDelayMs
    running: root.autoRevealed && !root.barHidden && !root.holding
    onTriggered: root.hideBar()
  }

  Connections {
    target: root.bar
    function onBarHiddenChanged() {
      if (root.barHidden) {
        root.autoRevealed = false
        root.pointerInBarBand = false
      }
    }
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        required property var modelData

        screen: modelData
        visible: root.barHidden || root.autoRevealed
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        implicitWidth: root.vertical ? root.revealThickness : 0
        implicitHeight: root.vertical ? 0 : root.revealThickness

        anchors {
          top: root.position === "top" || root.vertical
          bottom: root.position === "bottom" || root.vertical
          left: root.position === "left" || !root.vertical
          right: root.position === "right" || !root.vertical
        }

        WlrLayershell.namespace: "omarchy-bar-autohide-trigger"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        HoverHandler {
          onHoveredChanged: {
            root.edgeHovered = hovered
            if (hovered) root.showBar()
          }
        }
      }
    }
  }

  Component.onCompleted: root.setHidden(true)
  Component.onDestruction: root.setHidden(false)
}
