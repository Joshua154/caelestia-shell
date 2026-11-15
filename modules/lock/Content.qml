pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Caelestia
import Caelestia.Config
import qs.services

Item {
    id: root

    required property var lock

    // 0 = fully off screen, 1 = in place. Driven by the lock surface's animations
    property real reveal: 1

    readonly property int margin: Math.round(CUtils.clamp(height * 0.04, Tokens.padding.extraLarge, Tokens.padding.extraExtraLarge))
    readonly property real slide: (1 - reveal) * Tokens.padding.extraExtraLarge

    // Scale of the clock and login row, ~1 on a 1080p landscape screen
    readonly property real heroScale: CUtils.clamp(Math.min(height / 1080, width / 1100), 0.5, 2)

    // Ambient accent glow pooled behind the clock
    Shape {
        id: glow

        anchors.centerIn: hero
        // Pooled around the clock rather than the whole hero
        anchors.verticalCenterOffset: -hero.height * 0.3
        width: Math.min(parent.width, hero.width * 1.7)
        height: width
        preferredRendererType: Shape.CurveRenderer
        opacity: root.reveal

        ShapePath {
            strokeWidth: 0
            fillGradient: RadialGradient {
                centerX: glow.width / 2
                centerY: glow.height / 2
                focalX: centerX
                focalY: centerY
                centerRadius: glow.width / 2

                GradientStop {
                    position: 0
                    color: Qt.alpha(Colours.palette.m3primary, 0.12)
                }
                GradientStop {
                    position: 0.45
                    color: Qt.alpha(Colours.palette.m3primary, 0.04)
                }
                GradientStop {
                    position: 1
                    color: "transparent"
                }
            }

            PathRectangle {
                width: glow.width
                height: glow.height
            }
        }
    }

    Hero {
        id: hero

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        // Sits a touch above centre and rises into place while revealing
        anchors.verticalCenterOffset: Math.round(-parent.height * 0.06 + root.slide)

        width: Math.min(parent.width - root.margin * 2, Tokens.sizes.lock.centerWidth * Math.max(1, root.heroScale))

        lock: root.lock
        heroScale: root.heroScale
    }

    WeatherInfo {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: root.margin
        anchors.bottomMargin: root.margin - root.slide

        width: Math.min(implicitWidth, parent.width * 0.3)
        // Drop the hourly strip on short screens so the card stays a footnote
        showHourly: parent.height >= 800
    }

    Media {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.margin
        anchors.bottomMargin: root.margin - root.slide

        width: Math.min(implicitWidth, parent.width * 0.3)
        visible: Players.active !== null
    }

    NotifDock {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.margin - root.slide

        width: Math.min(Tokens.sizes.notifs.width, parent.width - root.margin * 2)
        // Room left between the login row and the bottom edge
        maxHeight: parent.height - root.margin - (hero.y + hero.height)

        lock: root.lock
    }

    StatusCluster {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: root.margin
        anchors.topMargin: root.margin - root.slide
    }

    SessionControls {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.margin
        anchors.topMargin: root.margin - root.slide

        visible: GlobalConfig.lock.enableSessionControls
    }
}
