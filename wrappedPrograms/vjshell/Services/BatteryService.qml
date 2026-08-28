pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property real lowThreshold: 0.20
    readonly property real criticalThreshold: 0.10
    readonly property real suspendThreshold: 0.05
    readonly property bool automaticSuspend: true

    readonly property bool available: !!(UPower.displayDevice?.isLaptopBattery ?? false) && !!(UPower.displayDevice?.isPresent ?? false)

    readonly property var device: UPower.displayDevice

    readonly property real energyRate: device?.changeRate ?? 0
    readonly property real timeToEmpty: device?.timeToEmpty ?? 0
    readonly property real timeToFull: device?.timeToFull ?? 0
    readonly property real healthPercentage: device?.healthPercentage ?? 0
    readonly property bool healthSupported: !!device?.healthSupported
    readonly property string model: device?.model ?? ""

    property var chargeState: device?.state ?? UPowerDeviceState.Unknown
    readonly property bool isCharging: chargeState == UPowerDeviceState.Charging
    readonly property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.FullyCharged || chargeState == UPowerDeviceState.PendingCharge
    readonly property int percentage: Math.round((device?.percentage ?? 1) * 100)

    readonly property bool isLow: available && percentage <= root.lowThreshold * 100
    readonly property bool isCritical: available && percentage <= root.criticalThreshold * 100
    readonly property bool isSuspending: available && percentage <= root.suspendThreshold * 100

    readonly property bool isLowAndNotCharging: available && isLow && !isCharging
    readonly property bool isCriticalAndNotCharging: available && isCritical && !isCharging
    readonly property bool isSuspendingAndNotCharging: available && automaticSuspend && isSuspending && !isCharging

    onIsLowAndNotChargingChanged: {
        if (isLowAndNotCharging)
            Quickshell.execDetached(["notify-send", "Low battery", "Consider plugging in your device", "-u", "critical", "-a", "Shell"]);
    }

    onIsCriticalAndNotChargingChanged: {
        if (isCriticalAndNotCharging)
            Quickshell.execDetached(["notify-send", "Critically low battery", "Please charge!\nAutomatic suspend triggers at %1%".arg(Math.round(root.suspendThreshold * 100)), "-u", "critical", "-a", "Shell"]);
    }

    onIsSuspendingAndNotChargingChanged: {
        if (isSuspendingAndNotCharging)
            Quickshell.execDetached(["sh", "-c", "systemctl suspend || loginctl suspend"]);
    }
}
