pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.services

Item {
    id: root

    required property real heroScale

    readonly property font clockFont: Tokens.font.headline.builders.large.scale(8 * heroScale).width(62).weight(Font.DemiBold).build()
    readonly property real digitHeight: digitMetrics.tightBoundingRect.height
    readonly property real topOff: digitMetrics.tightBoundingRect.y - digitMetrics.boundingRect.y
    readonly property int lineGap: Math.round(Tokens.spacing.largeIncreased * heroScale)

    implicitWidth: Math.max(hourMetrics.tightBoundingRect.width, minuteMetrics.tightBoundingRect.width + (amPm.active ? amPm.width + amPm.anchors.leftMargin : 0))
    implicitHeight: digitHeight * 2 + lineGap

    // Fixed reference so the layout doesn't jitter as the digits change
    TextMetrics {
        id: digitMetrics

        text: "0"
        font: root.clockFont
    }

    StyledText {
        id: hours

        x: -hourMetrics.tightBoundingRect.x
        y: -root.topOff

        text: Time.hourStr
        color: Colours.palette.m3primary
        font: root.clockFont

        TextMetrics {
            id: hourMetrics

            text: hours.text
            font: hours.font
        }
    }

    StyledText {
        id: minutes

        x: -minuteMetrics.tightBoundingRect.x
        y: root.digitHeight + root.lineGap - root.topOff

        text: Time.minuteStr
        color: Colours.palette.m3secondary
        font: root.clockFont

        TextMetrics {
            id: minuteMetrics

            text: minutes.text
            font: minutes.font
        }
    }

    Loader {
        id: amPm

        anchors.left: parent.left
        anchors.leftMargin: minuteMetrics.tightBoundingRect.width + Math.round(Tokens.spacing.large * root.heroScale)
        anchors.bottom: parent.bottom

        active: Units.twelveHourClock
        visible: active
        asynchronous: true

        sourceComponent: StyledRect {
            color: Colours.tPalette.m3surfaceContainerHigh
            radius: Tokens.rounding.full

            implicitWidth: amPmText.implicitWidth + Tokens.padding.large * 2
            implicitHeight: amPmText.implicitHeight + Tokens.padding.small * 2

            StyledText {
                id: amPmText

                anchors.centerIn: parent
                text: Time.amPmStr
                color: Colours.palette.m3onSurface
                font: Tokens.font.title.builders.large.scale(root.heroScale).weight(Font.DemiBold).build()
            }
        }
    }
}
