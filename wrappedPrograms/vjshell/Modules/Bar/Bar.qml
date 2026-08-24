import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Commons

PanelWindow {
    id: root

    required property ShellScreen modelData

    readonly property string screenName: modelData.name

    screen: modelData

    anchors {
        top: true
        bottom: !Style.barOnTop
        left: Style.barOnTop ? true : Style.barOnLeft
        right: Style.barOnTop ? true : !Style.barOnLeft
    }
    exclusiveZone: Style.barExclusive ? Style.barWidth : 0

    implicitWidth: Style.barWidth
    implicitHeight: Style.barWidth
    color: Theme.surface

    WlrLayershell.namespace: "vjshell-bar"

    Rectangle {
        visible: !Style.barOnTop
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: Style.barOnLeft ? undefined : parent.left
        anchors.right: Style.barOnLeft ? parent.right : undefined
        width: Style.dividerWidth
        color: Theme.surfaceVariant
    }

    Rectangle {
        visible: Style.barOnTop
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: Style.dividerWidth
        color: Theme.surfaceVariant
    }

    ColumnLayout {
        visible: !Style.barOnTop
        anchors.fill: parent
        anchors.topMargin: Style.barPadding
        anchors.bottomMargin: Style.barPadding
        spacing: Style.groupSpacing

        Logo {
            Layout.alignment: Qt.AlignHCenter
        }

        Projects {
            Layout.alignment: Qt.AlignHCenter
        }

        Workspaces {
            Layout.alignment: Qt.AlignHCenter
            screenName: root.screenName
        }

        Item {
            Layout.fillHeight: true
        }

        Item {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: Style.barWidth - Style.barInset * 2
            implicitHeight: cluster.implicitHeight + Style.spacing * 4

            Rectangle {
                anchors.fill: parent
                radius: Style.radiusL
                color: Theme.surfaceVariant
            }

            ColumnLayout {
                id: cluster

                x: 0
                y: Style.spacing * 2
                width: Style.barWidth - Style.barInset * 2
                spacing: Style.spacing * 2

                NotificationBell {
                    Layout.alignment: Qt.AlignHCenter
                }

                Volume {
                    Layout.alignment: Qt.AlignHCenter
                }

                Mic {
                    Layout.alignment: Qt.AlignHCenter
                }

                LyricsButton {
                    Layout.alignment: Qt.AlignHCenter
                }

                KeyboardLayout {
                    Layout.alignment: Qt.AlignHCenter
                    screenName: root.screenName
                }

                Clock {
                    Layout.alignment: Qt.AlignHCenter
                }

                SysTray {
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    RowLayout {
        visible: Style.barOnTop
        anchors.fill: parent
        anchors.leftMargin: Style.barPadding
        anchors.rightMargin: Style.barPadding
        spacing: Style.groupSpacing

        Logo {
            Layout.alignment: Qt.AlignVCenter
        }

        Projects {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: false
        }

        Workspaces {
            id: topWorkspaces

            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: false
            screenName: root.screenName
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: Style.spacing * 2

            NotificationBell {
                Layout.alignment: Qt.AlignVCenter
            }

            Volume {
                Layout.alignment: Qt.AlignVCenter
            }

            Mic {
                Layout.alignment: Qt.AlignVCenter
            }

            LyricsButton {
                Layout.alignment: Qt.AlignVCenter
            }

            KeyboardLayout {
                Layout.alignment: Qt.AlignVCenter
                screenName: root.screenName
            }

            Clock {
                Layout.alignment: Qt.AlignVCenter
            }

            SysTray {
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
