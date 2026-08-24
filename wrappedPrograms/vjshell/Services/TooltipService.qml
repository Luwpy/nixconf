pragma Singleton

import Quickshell

Singleton {
    id: root

    property string text: ""
    property real anchorX: 0
    property real anchorY: 0
    property string screenName: ""
    property bool shown: false

    function show(label, y, screen, x) {
        if (!label)
            return;
        text = label;
        anchorY = y;
        anchorX = x ?? 0;
        screenName = screen;
        shown = true;
    }

    function hide() {
        shown = false;
    }
}
