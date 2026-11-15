import QtQuick
import QtQuick.Effects
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.effects
import qs.services

Item {
    id: root

    required property real heroScale

    readonly property font timeFont: Tokens.font.clock.size(Math.max(1, Math.round(136 * heroScale))).weight(Font.Normal).letterSpacing(-Math.round(5 * heroScale), true).build()

    implicitWidth: timeRow.implicitWidth + (amPm.visible ? amPm.implicitWidth + amPm.anchors.leftMargin : 0)
    implicitHeight: timeRow.implicitHeight

    // Soft halo in the accent colour so the time floats off the wallpaper
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowBlur: 1
        blurMax: 48
        shadowColor: Colours.palette.m3primary
        shadowOpacity: 0.45
        shadowVerticalOffset: 0
    }

    Row {
        id: timeRow

        anchors.left: parent.left
        anchors.top: parent.top
        spacing: 0
        layer.enabled: true

        StyledText {
            id: hour

            text: Time.hourStr
            color: Colours.palette.m3onSurface
            font: root.timeFont
        }

        StyledText {
            id: colon

            text: ":"
            color: Colours.palette.m3primary
            font: root.timeFont

            // Slow breathing instead of a hard blink
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: root.visible

                NumberAnimation {
                    to: 0.3
                    duration: 1000
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: 1
                    duration: 1000
                    easing.type: Easing.InOutSine
                }
            }
        }

        StyledText {
            text: Time.minuteStr
            color: Colours.palette.m3onSurface
            font: root.timeFont
        }
    }

    // Accent tint that fades in towards the baseline, masked to the glyphs
    Rectangle {
        anchors.fill: timeRow

        gradient: Gradient {
            orientation: Gradient.Vertical

            GradientStop {
                position: 0.1
                color: "transparent"
            }
            GradientStop {
                position: 1
                color: Qt.alpha(Colours.palette.m3primary, 0.75)
            }
        }

        layer.enabled: true
        layer.effect: Mask {
            maskSource: timeRow
        }
    }

    StyledText {
        id: amPm

        anchors.left: timeRow.right
        anchors.leftMargin: Math.round(Tokens.spacing.medium * root.heroScale)
        y: hour.baselineOffset - baselineOffset

        visible: Units.twelveHourClock
        text: Time.amPmStr
        color: Colours.palette.m3primary
        font: Tokens.font.clock.size(Math.max(1, Math.round(28 * root.heroScale))).weight(Font.Medium).build()
    }
}
