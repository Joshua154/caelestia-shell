pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import M3Shapes
import Caelestia.Config
import Caelestia.Multimedia
import qs.components
import qs.components.effects
import qs.services
import qs.utils

Item {
    id: root

    required property int size
    // Lights up the halo while biometrics are scanning
    property bool active

    readonly property color bgColour: Colours.tPalette.m3surfaceContainerHighest

    implicitWidth: size
    implicitHeight: size

    // Accent halo behind the avatar
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowBlur: 1
        blurMax: 24
        shadowColor: Colours.palette.m3primary
        shadowOpacity: root.active ? 0.9 : 0.4
        shadowVerticalOffset: 0

        Behavior on shadowOpacity {
            Anim {}
        }
    }

    MaterialShape {
        id: shape

        anchors.centerIn: parent
        implicitSize: root.size

        shape: MaterialShape.Cookie9Sided
        color: Qt.alpha(root.bgColour, 1)
        opacity: root.bgColour.a
        layer.enabled: true

        // Gentle spin while scanning
        Anim on rotation {
            running: root.active
            from: 0
            to: 360
            duration: 6000
            easing.type: Easing.Linear
            loops: Animation.Infinite
            onRunningChanged: if (!running) shape.rotation = 0
        }
    }

    MaterialIcon {
        anchors.centerIn: parent

        text: "person"
        color: Colours.palette.m3onSurfaceVariant
        fontStyle: Tokens.font.icon.size(Math.max(1, Math.round(root.size * 0.45))).build()
        visible: !pfp.ready
    }

    Visual {
        id: pfp

        anchors.fill: shape
        source: `${Paths.home}/.face`

        layer.enabled: true
        layer.effect: Mask {
            maskSource: shape
        }
    }
}
