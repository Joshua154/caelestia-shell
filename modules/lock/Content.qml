pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia
import Caelestia.Config
import qs.components
import qs.services
import qs.modules.lock.weather

Item {
    id: root

    required property var lock

    // 0 = fully off screen, 1 = in place. Driven by the lock surface's animations
    property real reveal: 1

    readonly property bool portrait: height > width
    readonly property int margin: Math.round(CUtils.clamp(height * 0.045, Tokens.padding.extraLarge, Tokens.padding.extraExtraLarge * 1.5))
    readonly property real slide: (1 - reveal) * Tokens.padding.extraExtraLarge * 2

    // Scale of the clock and login row, ~1 on a 1080p landscape screen
    readonly property real heroScale: Math.min(leftPane.height / 1000, leftPane.width / 640)

    Item {
        id: leftPane

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: root.margin
        anchors.leftMargin: root.margin - root.slide

        width: parent.width - root.margin * 2 - (root.portrait ? 0 : rail.width + root.margin)
        height: root.portrait ? Math.round((parent.height - root.margin * 3) * 0.6) : parent.height - root.margin * 2

        WeatherInfo {
            anchors.left: parent.left
            anchors.top: parent.top
            width: Math.min(parent.width, implicitWidth)
        }

        Hero {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: Math.min(parent.width, Tokens.sizes.lock.centerWidth)

            lock: root.lock
            heroScale: root.heroScale
        }
    }

    ColumnLayout {
        id: rail

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.margin
        anchors.rightMargin: root.margin - root.slide

        width: root.portrait ? parent.width - root.margin * 2 : Math.min(Tokens.sizes.sidebar.width, Math.round(parent.width * 0.32))
        height: parent.height - root.margin * 2 - (root.portrait ? leftPane.height + root.margin : 0)

        spacing: Tokens.spacing.medium

        Forecast {
            Layout.fillWidth: true

            // Only when the rest of the rail keeps enough height for itself
            visible: rail.height - implicitHeight - rail.spacing >= Tokens.sizes.lock.showForecastHeight
        }

        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true

            radius: Tokens.rounding.extraLarge
            color: Colours.tPalette.m3surfaceContainer

            NotifDock {
                lock: root.lock
            }
        }

        Media {
            Layout.fillWidth: true
            visible: Players.active !== null
        }

        Fetch {
            Layout.fillWidth: true

            // Leave the room to the notifications on short screens
            compact: fullHeight > rail.height / 3
        }

        SessionControls {
            Layout.fillWidth: true
            visible: GlobalConfig.lock.enableSessionControls
        }
    }
}
