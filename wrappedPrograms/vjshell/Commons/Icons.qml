pragma Singleton

import Quickshell

Singleton {
    readonly property string bell: "notifications"
    readonly property string bellOff: "notifications_off"

    readonly property string volumeHigh: "volume_up"
    readonly property string volumeMedium: "volume_down"
    readonly property string volumeLow: "volume_mute"
    readonly property string volumeMuted: "volume_off"

    readonly property string micOn: "mic"
    readonly property string micOff: "mic_off"

    readonly property string keyboard: "keyboard"

    readonly property string bluetooth: "bluetooth"
    readonly property string bluetoothOff: "bluetooth_disabled"

    readonly property string wifi: "wifi"
    readonly property string wifiOff: "wifi_off"

    readonly property string headphones: "headphones"
    readonly property string mouse: "mouse"
    readonly property string phone: "smartphone"
    readonly property string speaker: "speaker"
    readonly property string gamepad: "sports_esports"
    readonly property string application: "apps"

    readonly property string calculate: "calculate"
    readonly property string copy: "content_copy"
    readonly property string close: "close"
    readonly property string clear: "clear_all"

    readonly property string calendar: "calendar_month"
    readonly property string today: "today"
    readonly property string chevronLeft: "chevron_left"
    readonly property string chevronRight: "chevron_right"

    readonly property string power: "power_settings_new"
    readonly property string batteryFull: "battery_full"
    readonly property string battery5Bar: "battery_5_bar"
    readonly property string battery4Bar: "battery_4_bar"
    readonly property string battery3Bar: "battery_3_bar"
    readonly property string battery2Bar: "battery_2_bar"
    readonly property string battery1Bar: "battery_1_bar"
    readonly property string battery0Bar: "battery_0_bar"
    readonly property string batteryCharging: "battery_charging_full"
    readonly property string batteryAlert: "battery_alert"
    readonly property string batteryUnknown: "battery_unknown"
    readonly property string search: "search"
    readonly property string terminal: "terminal"
    readonly property string remove: "delete"
    readonly property string link: "link"
    readonly property string linkOff: "link_off"
    readonly property string expandLess: "expand_less"
    readonly property string moreHoriz: "more_horiz"
    readonly property string emptyBell: "notifications_none"
    readonly property string emptyApps: "apps"
    readonly property string emptySearch: "search_off"

    readonly property string monitor: "monitor_heart"
    readonly property string cpu: "memory"
    readonly property string ram: "memory_alt"
    readonly property string gpu: "developer_board"
    readonly property string temperature: "thermostat"
    readonly property string uptime: "schedule"
    readonly property string load: "speed"
    readonly property string swap: "swap_horiz"
    readonly property string processes: "list_alt"
    readonly property string sort: "swap_vert"
    readonly property string pause: "pause"
    readonly property string resume: "play_arrow"
    readonly property string forceKill: "bolt"

    readonly property string lyrics: "lyrics"
    readonly property string check: "check"
    readonly property string reset: "restart_alt"
    readonly property string hourglassTop: "hourglass_top"
    readonly property string checkCircle: "check_circle"
    readonly property string help: "help"
    readonly property string error: "error"
    readonly property string musicNote: "music_note"
    readonly property string resize: "open_in_full"
    readonly property string rotate: "sync"
    readonly property string dragIndicator: "drag_indicator"

    function forBattery(percentage) {
        if (percentage >= 95)
            return batteryFull;
        if (percentage >= 80)
            return battery5Bar;
        if (percentage >= 60)
            return battery4Bar;
        if (percentage >= 40)
            return battery3Bar;
        if (percentage >= 20)
            return battery2Bar;
        if (percentage >= 5)
            return battery1Bar;
        return battery0Bar;
    }

    function forBluetoothDevice(iconName) {
        const name = iconName || "";
        if (name.includes("headset") || name.includes("headphone"))
            return headphones;
        if (name.includes("keyboard"))
            return keyboard;
        if (name.includes("mouse") || name.includes("pointing"))
            return mouse;
        if (name.includes("phone"))
            return phone;
        if (name.includes("audio") || name.includes("speaker"))
            return speaker;
        if (name.includes("gaming") || name.includes("joystick"))
            return gamepad;
        return bluetooth;
    }
}
