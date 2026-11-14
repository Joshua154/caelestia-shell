pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Caelestia.Config
import Caelestia.I18n
import Caelestia.Services
import qs.components
import qs.components.controls
import qs.components.effects
import qs.services
import qs.utils

StyledRect {
    id: root

    // Drops the logo and info lines, leaving only the meters
    property bool compact

    readonly property real detailWidth: Math.max(cpuMeter.detailWidth, memMeter.detailWidth, diskMeter.detailWidth)
    // Height when not compact. Summed by hand so it doesn't depend on compact itself
    readonly property real fullHeight: header.implicitHeight + info.implicitHeight + meters.implicitHeight + meters.Layout.topMargin + layout.spacing * 2 + layout.anchors.margins * 2

    implicitHeight: layout.implicitHeight + layout.anchors.margins * 2
    radius: Tokens.rounding.extraLarge
    color: Colours.tPalette.m3surfaceContainer

    ServiceRef {
        service: Cpu
    }

    ServiceRef {
        service: Memory
    }

    ServiceRef {
        service: Storage
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: Tokens.padding.largeIncreased

        spacing: Tokens.spacing.medium

        RowLayout {
            id: header

            Layout.fillWidth: true
            spacing: Tokens.spacing.medium

            StyledRect {
                implicitWidth: prompt.implicitWidth + Tokens.padding.medium * 2
                implicitHeight: prompt.implicitHeight + Tokens.padding.small * 2

                color: Colours.palette.m3primary
                radius: Tokens.rounding.medium

                MonoText {
                    id: prompt

                    anchors.centerIn: parent
                    text: ">"
                    color: Colours.palette.m3onPrimary
                }
            }

            MonoText {
                Layout.fillWidth: true
                text: "caelestiafetch.sh"
                elide: Text.ElideRight
            }
        }

        RowLayout {
            id: info

            // Collapsed instead of hidden so its implicit height stays known for fullHeight
            Layout.fillWidth: true
            Layout.preferredHeight: root.compact ? 0 : implicitHeight
            Layout.topMargin: root.compact ? -layout.spacing : 0
            spacing: Tokens.spacing.extraLarge
            opacity: root.compact ? 0 : 1

            Loader {
                Layout.fillHeight: true
                Layout.leftMargin: Tokens.padding.small
                Layout.preferredWidth: height

                active: root.width > Tokens.sizes.lock.largeLogoWidth
                visible: active
                asynchronous: true

                sourceComponent: SysInfo.isDefaultLogo ? caelestiaLogo : distroIcon
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.topMargin: Tokens.padding.extraSmall
                Layout.bottomMargin: Tokens.padding.extraSmall
                spacing: Tokens.spacing.small

                Repeater {
                    model: {
                        const items = [];

                        // TRANSLATORS: keep the label padded to 4 chars so the column stays aligned
                        items.push(Tr.tr("OS  : %1").arg(SysInfo.osPrettyName || SysInfo.osName));
                        // TRANSLATORS: keep the label padded to 4 chars so the column stays aligned
                        items.push(Tr.tr("WM  : %1").arg(SysInfo.wm));
                        // TRANSLATORS: keep the label padded to 4 chars so the column stays aligned
                        items.push(Tr.tr("UP  : %1").arg(SysInfo.uptime));

                        if (UPower.displayDevice.isLaptopBattery) {
                            const charging = [UPowerDeviceState.Charging, UPowerDeviceState.FullyCharged, UPowerDeviceState.PendingCharge].includes(UPower.displayDevice.state);
                            const pct = Math.round(UPower.displayDevice.percentage * 100);
                            // TRANSLATORS: keep the label padded to 4 chars, (+) marks charging
                            items.push(charging ? Tr.tr("BATT: (+) %1%").arg(pct) : Tr.tr("BATT: %1%").arg(pct));
                        }

                        return items;
                    }

                    MonoText {
                        required property string modelData

                        Layout.fillWidth: true
                        text: modelData
                        elide: Text.ElideRight
                    }
                }
            }
        }

        ColumnLayout {
            id: meters

            Layout.fillWidth: true
            Layout.topMargin: Tokens.spacing.extraSmall
            spacing: Tokens.spacing.small

            Meter {
                id: cpuMeter

                // TRANSLATORS: short label for CPU usage, at most 4 chars
                label: Tr.tr("CPU")
                value: Cpu.percentage
                detail: `${Strings.percentOne(Cpu.percentage)} ${Units.formatSensorTemp(Cpu.temperature)}`
                colour: Cpu.temperature > 90 ? Colours.palette.m3error : Colours.palette.m3primary
            }

            Meter {
                id: memMeter

                // TRANSLATORS: short label for memory usage, at most 4 chars
                label: Tr.tr("MEM")
                value: Memory.percentage
                detail: Strings.percentOne(Memory.percentage)
                colour: Colours.palette.m3tertiary
            }

            Meter {
                id: diskMeter

                // TRANSLATORS: short label for storage usage, at most 4 chars
                label: Tr.tr("DISK")
                value: Storage.percentage
                detail: Strings.percentOne(Storage.percentage)
                colour: Colours.palette.m3secondary
            }
        }
    }

    Component {
        id: caelestiaLogo

        Logo {
            width: height
        }
    }

    Component {
        id: distroIcon

        ColouredIcon {
            source: SysInfo.osLogo
            implicitSize: height
            colour: Colours.palette.m3primary
            layer.enabled: Config.lock.recolourLogo
        }
    }

    component MonoText: StyledText {
        font: root.width > Tokens.sizes.lock.largeFontWidth ? Tokens.font.mono.medium : Tokens.font.mono.small
    }

    component Meter: RowLayout {
        id: meter

        required property string label
        required property real value
        required property string detail
        required property color colour
        readonly property alias detailWidth: detailText.implicitWidth

        Layout.fillWidth: true
        spacing: Tokens.spacing.medium

        MonoText {
            text: meter.label.padEnd(4)
            color: Colours.palette.m3onSurfaceVariant
        }

        StyledProgressBar {
            Layout.fillWidth: true
            implicitHeight: Tokens.padding.small

            value: meter.value
            fgColour: meter.colour
            bgColour: Colours.layer(Colours.palette.m3surfaceContainerHighest, 2)
        }

        MonoText {
            id: detailText

            // Same width for every meter so the bars line up
            Layout.preferredWidth: root.detailWidth
            text: meter.detail
            color: meter.colour
        }
    }
}
