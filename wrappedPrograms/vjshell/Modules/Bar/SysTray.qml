pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.Commons
import qs.Services
import qs.Widgets

Item {
    id: root

    readonly property bool horizontal: Style.barOnTop

    property bool expanded: false

    implicitWidth: root.horizontal ? rowLay.implicitWidth : colLay.implicitWidth
    implicitHeight: root.horizontal ? rowLay.implicitHeight : colLay.implicitHeight

    ColumnLayout {
        id: colLay

        visible: !root.horizontal
        width: root.width
        spacing: Style.spacing

        ToggleButton {
            Layout.alignment: Qt.AlignHCenter
        }

        ColumnLayout {
            id: itemsCol

            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: root.expanded ? implicitHeight : 0

            spacing: Style.spacing
            clip: true
            opacity: root.expanded ? 1 : 0

            Behavior on Layout.preferredHeight {
                NumberAnimation {
                    duration: Style.durMorph
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.emphasized
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Style.durState
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
            }

            Repeater {
                model: SystemTray.items

                delegate: TrayEntry {
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    RowLayout {
        id: rowLay

        visible: root.horizontal
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.spacing

        RowLayout {
            id: itemsRow

            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: root.expanded ? implicitWidth : 0

            spacing: Style.spacing
            clip: true
            opacity: root.expanded ? 1 : 0

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: Style.durMorph
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.emphasized
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Style.durState
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
            }

            Repeater {
                model: SystemTray.items

                delegate: TrayEntry {
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        ToggleButton {
            Layout.alignment: Qt.AlignVCenter
        }
    }

    component ToggleButton: Item {
        id: toggle

        implicitWidth: Style.itemSize
        implicitHeight: Style.itemSize
        visible: SystemTray.items.values.length > 0

        StateLayer {
            id: toggleState
            cornerRadius: Style.radiusS
            hovered: toggleHover.hovered
            pressed: toggleTap.pressed
        }

        MaterialIcon {
            anchors.centerIn: parent
            text: root.expanded ? Icons.expandLess : Icons.moreHoriz
            color: Theme.textDim

            scale: toggleTap.pressed ? Style.pressScale : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: Style.durShort2
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
            }
        }

        HoverHandler {
            id: toggleHover
        }

        TapHandler {
            id: toggleTap
            onPressedChanged: {
                if (pressed)
                    toggleState.press(point.position.x, point.position.y);
                else
                    toggleState.release();
            }
            onTapped: root.expanded = !root.expanded
        }
    }

    component TrayEntry: Item {
        id: entry

        required property SystemTrayItem modelData

        implicitWidth: Style.itemSize
        implicitHeight: Style.itemSize

        StateLayer {
            id: state
            cornerRadius: Style.radiusS
            hovered: mouse.containsMouse
            pressed: mouse.pressed
        }

        IconImage {
            anchors.centerIn: parent
            implicitSize: Style.iconSize
            source: entry.modelData.icon

            scale: mouse.pressed ? Style.pressScale : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: Style.durShort2
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            onPressed: event => state.press(event.x, event.y)
            onReleased: state.release()
            onCanceled: state.release()

            onClicked: event => {
                switch (event.button) {
                case Qt.LeftButton:
                    entry.modelData.activate();
                    break;
                case Qt.MiddleButton:
                    entry.modelData.secondaryActivate();
                    break;
                case Qt.RightButton:
                    if (entry.modelData.hasMenu) {
                        const pos = entry.mapToItem(null, 0, 0);
                        TrayMenuService.show(entry.modelData.menu, pos.y, pos.x + entry.width / 2);
                    }
                    break;
                }
            }
        }
    }
}
