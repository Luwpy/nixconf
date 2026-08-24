pragma Singleton

import Quickshell

Singleton {
    id: root

    property var handle: null
    property real anchorX: 0
    property real anchorY: 0
    property bool open: false

    function show(menuHandle, y, x) {
        handle = menuHandle;
        anchorY = y;
        anchorX = x ?? 0;
        open = true;
    }

    function close() {
        open = false;
    }
}
