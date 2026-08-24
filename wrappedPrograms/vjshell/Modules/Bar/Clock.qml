import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

Item {
    id: root

    readonly property bool open: PanelService.isOpen("calendar")
    readonly property bool horizontal: Style.barOnTop

    implicitWidth: (root.horizontal ? rowLay.implicitWidth : column.implicitWidth) + Style.spacing * 2
    implicitHeight: (root.horizontal ? rowLay.implicitHeight : column.implicitHeight) + Style.spacing * 2

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
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

        Line {
            text: Qt.formatDateTime(clock.date, "HH")
            color: root.open ? Theme.accent : Theme.textBright
        }
        Line {
            text: Qt.formatDateTime(clock.date, "mm")
            color: root.open ? Theme.accent : Theme.textBright
        }
        Line {
            text: "-"
            color: Theme.textDim
        }
        Line {
            text: Qt.formatDateTime(clock.date, "dd")
        }
        Line {
            text: Qt.formatDateTime(clock.date, "MM")
            color: Theme.textDim
        }
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

        Line {
            text: Qt.formatDateTime(clock.date, "HH:mm")
            font.pixelSize: Style.fontSizeLarge
            color: root.open ? Theme.accent : Theme.textBright
        }
        Line {
            text: Qt.formatDateTime(clock.date, "dd/MM")
            color: root.open ? Theme.accent : Theme.textDim
        }
    }

    component Line: Text {
        Layout.alignment: Qt.AlignHCenter
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSize
        font.weight: Font.Bold
        color: Theme.textBright

        Behavior on color {
            ColorAnimation {
                duration: Style.durState
                easing.type: Easing.Bezier
                easing.bezierCurve: Style.standard
            }
        }
    }

    HoverHandler {
        id: hover
    }

    TapHandler {
        id: tap
        onPressedChanged: {
            if (pressed)
                state.press(point.position.x, point.position.y);
            else
                state.release();
        }
        onTapped: PanelService.toggle("calendar")
    }
}
