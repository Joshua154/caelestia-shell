import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import Caelestia.Config
import qs.components
import qs.services
import qs.utils

// Tiny glanceable status pill: network, bluetooth and battery
GlassCard {
    id: root

    readonly property bool charging: [UPowerDeviceState.Charging, UPowerDeviceState.FullyCharged, UPowerDeviceState.PendingCharge].includes(UPower.displayDevice.state)

    implicitWidth: layout.implicitWidth + Tokens.padding.large * 2
    implicitHeight: layout.implicitHeight + Tokens.padding.medium * 2

    radius: Tokens.rounding.full

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Tokens.spacing.medium

        MaterialIcon {
            animate: true
            text: Nmcli.activeEthernet ? "cable" : Nmcli.active ? Icons.getNetworkIcon(Nmcli.active.strength ?? 0) : "wifi_off"
            color: Colours.palette.m3onSurfaceVariant
        }

        MaterialIcon {
            visible: Bluetooth.defaultAdapter?.enabled ?? false
            animate: true
            text: Bluetooth.devices.values.some(d => d.connected) ? "bluetooth_connected" : "bluetooth"
            color: Colours.palette.m3onSurfaceVariant
        }

        RowLayout {
            visible: UPower.displayDevice.isLaptopBattery
            spacing: Tokens.spacing.extraSmall

            MaterialIcon {
                animate: true
                text: Icons.getBatteryIcon(UPower.displayDevice.percentage, root.charging)
                color: !UPower.onBattery || UPower.displayDevice.percentage > 0.2 ? Colours.palette.m3onSurfaceVariant : Colours.palette.m3error
                fill: 1
            }

            StyledText {
                animate: true
                text: `${Math.round(UPower.displayDevice.percentage * 100)}%`
                color: Colours.palette.m3onSurface
                font: Tokens.font.body.builders.medium.weight(Font.Medium).build()
            }
        }
    }
}
