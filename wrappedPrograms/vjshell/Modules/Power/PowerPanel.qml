import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.Commons
import qs.Services
import qs.Widgets

Panel {
    id: root

    panelName: "power"
    title: "Power"
    icon: Icons.power

    readonly property bool hasBattery: BatteryService.available

    readonly property string stateLabel: {
        if (!hasBattery)
            return "No battery";
        if (BatteryService.isCharging)
            return "Charging";
        if (BatteryService.isPluggedIn)
            return "Fully charged";
        return "On battery";
    }

    readonly property string timeLabel: {
        if (!hasBattery)
            return "";
        const seconds = BatteryService.isCharging ? BatteryService.timeToFull : BatteryService.timeToEmpty;
        if (!(seconds > 0))
            return "";
        return root.formatTime(seconds) + (BatteryService.isCharging ? " until full" : " remaining");
    }

    function formatTime(seconds) {
        const total = Math.round(seconds);
        const h = Math.floor(total / 3600);
        const m = Math.floor((total % 3600) / 60);
        if (h > 0)
            return h + "h " + String(m).padStart(2, "0") + "m";
        return m + "m";
    }

    RowLayout {
        Layout.fillWidth: true
        visible: root.hasBattery
        spacing: Style.spacing

        Gauge {
            visible: root.hasBattery
            Layout.fillWidth: true
            value: BatteryService.percentage / 100
            invertColor: true
            label: "Battery"
            sub: root.stateLabel
        }
    }

    RowLayout {
        Layout.fillWidth: true
        visible: root.hasBattery
        spacing: Style.spacing

        Chip {
            Layout.fillWidth: true
            icon: Icons.power
            label: root.stateLabel
        }

        Chip {
            Layout.fillWidth: true
            visible: BatteryService.energyRate > 0
            icon: Icons.batteryCharging
            label: BatteryService.energyRate.toFixed(1) + " W"
        }

        Chip {
            Layout.fillWidth: true
            visible: root.timeLabel !== ""
            icon: Icons.hourglassTop
            label: root.timeLabel
        }

        Chip {
            Layout.fillWidth: true
            visible: BatteryService.healthSupported && BatteryService.healthPercentage > 0
            icon: Icons.temperature
            label: "Health " + Math.round(BatteryService.healthPercentage) + "%"
        }
    }

    Text {
        Layout.fillWidth: true
        visible: BatteryService.model !== ""
        text: BatteryService.model
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSizeSmall
        color: Theme.textDim
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: Style.dividerWidth
        color: Theme.surfaceHigh
    }

    Text {
        Layout.fillWidth: true
        text: "Power profile"
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSizeSmall
        color: Theme.textDim
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.spacing

        PanelButton {
            Layout.fillWidth: true
            text: "Power saver"
            accent: PowerProfiles.profile === PowerProfile.PowerSaver
            onClicked: PowerProfiles.profile = PowerProfile.PowerSaver
        }

        PanelButton {
            Layout.fillWidth: true
            text: "Balanced"
            accent: PowerProfiles.profile === PowerProfile.Balanced
            onClicked: PowerProfiles.profile = PowerProfile.Balanced
        }

        PanelButton {
            Layout.fillWidth: true
            visible: PowerProfiles.hasPerformanceProfile
            text: "Performance"
            accent: PowerProfiles.profile === PowerProfile.Performance
            onClicked: PowerProfiles.profile = PowerProfile.Performance
        }
    }

    component Chip: RowLayout {
        id: chip

        property string icon: ""
        property string label: ""

        spacing: 2

        MaterialIcon {
            text: chip.icon
            font.pixelSize: Style.fontSize
            color: Theme.textDim
        }

        Text {
            Layout.fillWidth: true
            text: chip.label
            elide: Text.ElideRight
            font.family: Style.fontFamily
            font.pixelSize: Style.fontSizeSmall
            color: Theme.textDim
        }
    }
}
