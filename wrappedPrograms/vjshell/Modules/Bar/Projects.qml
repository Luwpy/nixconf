pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services

Item {
    id: root

    readonly property int projectCount: ProjectService.projectCount
    readonly property var visibleSlots: ProjectService.visibleSlots
    readonly property int agentDotSize: 5
    readonly property int agentDotMax: 4

    readonly property bool horizontal: Style.barOnTop

    Layout.fillWidth: true
    implicitWidth: root.horizontal ? rowLay.implicitWidth : colLay.implicitWidth
    implicitHeight: root.horizontal ? rowLay.implicitHeight : colLay.implicitHeight

    function blockStart(visible) {
        let start = 1;
        for (let v = 1; v < visible; v++)
            start += root.visibleSlots.includes(v) ? root.projectCount : 1;
        return start;
    }

    function realTag(project, visible) {
        const start = root.blockStart(visible);
        return root.visibleSlots.includes(visible) ? start + project - 1 : start;
    }

    function projectOccupied(project) {
        for (const visible of root.visibleSlots) {
            const real = root.realTag(project, visible);
            for (const name in MangoService.outputs) {
                const tag = (MangoService.outputs[name].tags || [])[real - 1];
                if (tag && tag.clients > 0)
                    return true;
            }
        }
        return false;
    }

    function activityColor(activity) {
        switch (activity) {
        case "blocked":
            return Theme.urgent;
        case "working":
            return Theme.warning;
        case "idle":
            return Theme.active;
        default:
            return Theme.textDim;
        }
    }

    ColumnLayout {
        id: colLay

        visible: !root.horizontal
        width: root.width
        spacing: Style.spacing

        Repeater {
            model: root.projectCount

            delegate: Slot {}
        }
    }

    Row {
        id: rowLay

        visible: root.horizontal
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.spacing

        Repeater {
            model: root.projectCount

            delegate: SlotH {}
        }
    }

    component PillBox: Item {
        id: pillBox

        required property int projectId
        required property bool active
        required property bool visited
        required property string activity
        required property bool shown

        implicitWidth: Style.dotSize
        implicitHeight: root.horizontal || pillBox.shown ? Style.dotSize : 0
        visible: implicitHeight > 0.5

        Behavior on implicitHeight {
            NumberAnimation {
                duration: Style.durMorph
                easing.type: Easing.Bezier
                easing.bezierCurve: Style.emphasized
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
            anchors.rightMargin: Style.spacing

            width: Style.accentBarWidth
            height: parent.height
            radius: width / 2

            color: Theme.textBright
            opacity: pillBox.active ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: Style.durState
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: parent.width + 6
            height: parent.height + 6
            radius: Style.radiusS

            color: Theme.urgent
            opacity: 0

            SequentialAnimation on opacity {
                running: pillBox.activity === "blocked"
                loops: Animation.Infinite
                alwaysRunToEnd: true

                NumberAnimation {
                    to: 0.45
                    duration: Style.durMedium4
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
                NumberAnimation {
                    to: 0
                    duration: Style.durMedium4
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Style.standard
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: Style.radiusXs

            color: root.activityColor(pillBox.activity)
            opacity: pillBox.active ? 1.0 : pillBox.visited ? 0.55 : 0.3

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
                onTapped: ProjectService.switchTo(pillBox.projectId)
            }
        }
    }

    component AgentDots: Row {
        id: dots

        required property var agents

        spacing: 2

        Repeater {
            model: dots.agents.slice(0, root.agentDotMax)

            delegate: Rectangle {
                required property var modelData

                width: root.agentDotSize
                height: root.agentDotSize
                radius: root.agentDotSize / 2

                color: root.activityColor(ProjectService.agentActivity(modelData))

                Behavior on color {
                    ColorAnimation {
                        duration: Style.durState
                        easing.type: Easing.Bezier
                        easing.bezierCurve: Style.standard
                    }
                }
            }
        }
    }

    component Slot: Column {
        id: slot

        required property int index
        readonly property int projectId: index + 1
        readonly property bool active: ProjectService.active === projectId
        readonly property bool visited: ProjectService.mru.indexOf(projectId) >= 0
        readonly property bool occupied: root.projectOccupied(projectId)
        readonly property var agents: ProjectService.agentsFor(projectId)
        readonly property string activity: ProjectService.activityFor(projectId)
        readonly property bool shown: active || occupied || agents.length > 0

        Layout.alignment: Qt.AlignHCenter
        spacing: 2
        visible: implicitHeight > 0.5

        PillBox {
            projectId: slot.projectId
            active: slot.active
            visited: slot.visited
            activity: slot.activity
            shown: slot.shown
        }

        AgentDots {
            x: (slot.width - width) / 2
            visible: slot.shown && slot.agents.length > 0
            agents: slot.agents
        }
    }

    component SlotH: Row {
        id: slot

        required property int index
        readonly property int projectId: index + 1
        readonly property bool active: ProjectService.active === projectId
        readonly property bool visited: ProjectService.mru.indexOf(projectId) >= 0
        readonly property bool occupied: root.projectOccupied(projectId)
        readonly property var agents: ProjectService.agentsFor(projectId)
        readonly property string activity: ProjectService.activityFor(projectId)
        readonly property bool shown: active || occupied || agents.length > 0

        spacing: 2
        visible: shown

        PillBox {
            anchors.verticalCenter: parent.verticalCenter
            projectId: slot.projectId
            active: slot.active
            visited: slot.visited
            activity: slot.activity
            shown: slot.shown
        }

        AgentDots {
            anchors.verticalCenter: parent.verticalCenter
            visible: slot.agents.length > 0
            agents: slot.agents
        }
    }
}
