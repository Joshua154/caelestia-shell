pragma ComponentBehavior: Bound

import QtQuick
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
    readonly property color bgColour: Colours.tPalette.m3surfaceContainerHighest

    implicitWidth: size
    implicitHeight: size

    MaterialShape {
        id: shape

        anchors.centerIn: parent
        implicitSize: root.size

        shape: MaterialShape.Cookie9Sided
        color: Qt.alpha(root.bgColour, 1)
        opacity: root.bgColour.a
        layer.enabled: true
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
