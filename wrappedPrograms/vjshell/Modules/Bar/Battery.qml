import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

Item {
    id: root

    readonly property bool horizontal: Style.barOnTop
    readonly property bool open: PanelService.isOpen("power")

    visible: BatteryService.available

    implicitWidth: (root.horizontal ? rowLay.implicitWidth : column.implicitWidth) + Style.spacing * 2
    implicitHeight: (root.horizontal ? rowLay.implicitHeight : column.implicitHeight) + Style.spacing * 2

    readonly property color stateColor: {
        if (BatteryService.isCritical)
            return Theme.urgent;
        if (BatteryService.isLow)
            return Theme.warning;
        if (root.open || BatteryService.isCharging)
            return Theme.accent;
        return Theme.text;
    }

    readonly property string icon: {
        if (BatteryService.isCritical)
            return Icons.batteryAlert;
        if (BatteryService.isCharging)
            return Icons.batteryCharging;
        return Icons.forBattery(BatteryService.percentage);
    }

    readonly property string tooltip: {
        if (!BatteryService.available)
            return "";
        const state = BatteryService.isCharging ? "Charging" : BatteryService.isPluggedIn ? "Fully charged" : "On battery";
        const time = BatteryService.isCharging ? BatteryService.timeToFull : BatteryService.timeToEmpty;
        const parts = [BatteryService.percentage + "%"];
        if (time > 0)
            parts.push(root.formatTime(time));
        return state + "  " + parts.join(" · ");
    }

    function formatTime(seconds) {
        const total = Math.round(seconds);
        const h = Math.floor(total / 3600);
        const m = Math.floor((total % 3600) / 60);
        if (h > 0)
            return h + "h " + String(m).padStart(2, "0") + "m";
        return m + "m";
    }

    StateLayer {
        id: state
        cornerRadius: Style.radiusS
        hovered: hover.hovered
        pressed: tap.pressed
    }

    ColumnLayout {
        id: column
        visible: !root.horizontal
        anchors.centerIn: parent
        spacing: 0

        scale: tap.pressed ? Style.pressScale : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: Style.durShort2
                easing.type: Easing.Bezier
                easing.bezierCurve: Style.standard
            }
        }

        MaterialIcon {
            Layout.alignment: Qt.AlignHCenter
            text: root.icon
            font.pixelSize: Style.iconSize
            color: root.stateColor
        }
        Percent {}
    }

    RowLayout {
        id: rowLay
        visible: root.horizontal
        anchors.centerIn: parent
        spacing: Style.spacing

        scale: tap.pressed ? Style.pressScale : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: Style.durShort2
                easing.type: Easing.Bezier
                easing.bezierCurve: Style.standard
            }
        }

        MaterialIcon {
            text: root.icon
            font.pixelSize: Style.iconSize
            color: root.stateColor
        }
        Percent {}
    }

    component Percent: Text {
        Layout.alignment: Qt.AlignHCenter
        text: BatteryService.percentage + "%"
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSizeSmall
        font.weight: Font.Bold
        color: root.stateColor

        Behavior on color {
            ColorAnimation {
                duration: Style.durState
                easing.type: Easing.Bezier
                easing.bezierCurve: Style.standard
            }
        }
    }

    Timer {
        id: tooltipTimer
        interval: Style.tooltipDelay
        onTriggered: {
            const pos = root.mapToItem(null, 0, 0);
            TooltipService.show(root.tooltip, pos.y + root.height / 2, QsWindow.window?.screen?.name ?? "", pos.x + root.width / 2);
        }
    }

    onTooltipChanged: if (TooltipService.shown && hover.hovered)
        TooltipService.text = tooltip

    HoverHandler {
        id: hover
        onHoveredChanged: {
            if (hovered && root.tooltip !== "")
                tooltipTimer.restart();
            else {
                tooltipTimer.stop();
                TooltipService.hide();
            }
        }
    }

    TapHandler {
        id: tap
        onPressedChanged: {
            if (pressed)
                state.press(point.position.x, point.position.y);
            else
                state.release();
        }
        onTapped: PanelService.toggle("power")
    }
}
