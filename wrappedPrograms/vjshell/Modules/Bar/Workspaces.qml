pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services

Item {
    id: root

    required property string screenName

    readonly property bool horizontal: Style.barOnTop

    Layout.fillWidth: true
    implicitWidth: root.horizontal ? rowLay.implicitWidth : colLay.implicitWidth
    implicitHeight: root.horizontal ? rowLay.implicitHeight : colLay.implicitHeight

    ColumnLayout {
        id: colLay

        visible: !root.horizontal
        width: root.width
        spacing: 0

        Repeater {
            model: ProjectService.entries.length

            delegate: Dot {
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    Row {
        id: rowLay

        visible: root.horizontal
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Repeater {
            model: ProjectService.entries.length

            delegate: Dot {}
        }
    }

    component Dot: Item {
        id: cell

        required property int index

        readonly property var entry: ProjectService.entries[index] || null
        readonly property var tag: entry ? (MangoService.tagsFor(root.screenName)[entry.real - 1] || null) : null
        readonly property bool isActive: !!(tag && tag.active)
        readonly property bool isUrgent: !!(tag && tag.urgent)
        readonly property bool shown: isActive || !!(tag && tag.clients > 0)
        readonly property real barLength: Style.dotSize

        implicitWidth: !root.horizontal || cell.shown ? Style.dotSize : 0
        implicitHeight: root.horizontal || cell.shown ? barLength + Style.spacing : 0
        visible: implicitWidth > 0.5 && implicitHeight > 0.5

        Behavior on implicitWidth {
            NumberAnimation {
                duration: Style.durMorph
                easing.type: Easing.Bezier
                easing.bezierCurve: Style.emphasized
            }
        }

        Behavior on implicitHeight {
            NumberAnimation {
                duration: Style.durMorph
                easing.type: Easing.Bezier
                easing.bezierCurve: Style.emphasized
            }
        }

        Rectangle {
            id: dot

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            width: Style.dotSize
            height: Math.max(0, Math.min(cell.barLength, cell.height - Style.spacing))
            radius: width / 2

            color: cell.isUrgent ? Theme.urgent : cell.isActive ? Theme.textBright : Theme.textDim
            opacity: cell.shown ? (cell.isActive ? 1.0 : 0.45) : 0.0

            scale: tap.pressed ? 0.9 : hover.hovered ? 1.12 : 1.0
            transformOrigin: Item.Center

            Behavior on color {
                ColorAnimation {
                    duration: Style.durState
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: Style.durState
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: Style.durState
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
            }

            HoverHandler {
                id: hover
            }

            TapHandler {
                id: tap
                onTapped: ProjectService.view(cell.entry ? cell.entry.visible : cell.index + 1)
            }
        }
    }
}
