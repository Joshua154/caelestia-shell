pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.services

GlassCard {
    id: root

    property bool showHourly: true

    // Next few hours in three-hour steps
    readonly property list<var> hours: [0, 3, 6, 9].map(i => Weather.hourlyForecast[i]).filter(h => h !== undefined)

    implicitWidth: layout.implicitWidth + Tokens.padding.large * 2
    implicitHeight: layout.implicitHeight + Tokens.padding.large * 2

    Timer {
        running: true
        triggeredOnStart: true
        repeat: true
        interval: 900000 // 15 minutes
        onTriggered: Weather.reload()
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: Tokens.padding.large
        spacing: Tokens.spacing.medium

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.large

            MaterialIcon {
                animate: true
                text: Weather.icon
                color: Colours.palette.m3primary
                fontStyle: Tokens.font.icon.builders.extraLarge.scale(1.4).build()
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                RowLayout {
                    spacing: Tokens.spacing.small

                    StyledText {
                        animate: true
                        text: Weather.temp
                        color: Colours.palette.m3onSurface
                        font: Tokens.font.headline.builders.medium.weight(Font.Medium).build()
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignBaseline
                        animate: true
                        text: {
                            const today = Weather.forecast[0];
                            // TRANSLATORS: %1/%2 = today's max and min temperature, units already included
                            return Tr.tr("High %1 • Low %2").arg(Weather.formatTemp(today?.maxTempC)).arg(Weather.formatTemp(today?.minTempC));
                        }
                        color: Colours.palette.m3outline
                        font: Tokens.font.body.small
                    }
                }

                StyledText {
                    Layout.fillWidth: true
                    animate: true
                    text: Weather.city ? `${Weather.description} · ${Weather.city}` : Weather.description
                    color: Colours.palette.m3onSurfaceVariant
                    font: Tokens.font.body.medium
                    elide: Text.ElideRight
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            visible: hourly.visible
            implicitHeight: 1
            color: Qt.alpha(Colours.palette.m3outlineVariant, 0.5)
        }

        RowLayout {
            id: hourly

            Layout.fillWidth: true
            visible: root.showHourly && root.hours.length > 1
            spacing: Tokens.spacing.large

            Repeater {
                model: root.hours

                // Plain Item so the layout may stretch it: a layout's own
                // maximum width is capped by its fixed-size children
                Item {
                    id: slot

                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    implicitWidth: column.implicitWidth
                    implicitHeight: column.implicitHeight

                    ColumnLayout {
                        id: column

                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: Tokens.spacing.extraSmall / 2

                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: slot.index === 0 ? Tr.tr("Now") : Units.twelveHourClock ? `${slot.modelData.hour % 12 || 12}${slot.modelData.hour < 12 ? "am" : "pm"}` : `${String(slot.modelData.hour).padStart(2, "0")}:00`
                            color: Colours.palette.m3outline
                            font: Tokens.font.label.small
                        }

                        MaterialIcon {
                            Layout.alignment: Qt.AlignHCenter
                            text: slot.modelData.icon
                            color: Colours.palette.m3onSurfaceVariant
                        }

                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: Weather.formatTemp(slot.modelData.tempC, true)
                            color: Colours.palette.m3onSurface
                            font: Tokens.font.body.builders.small.weight(Font.Medium).build()
                        }
                    }
                }
            }
        }
    }
}
