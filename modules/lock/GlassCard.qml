import QtQuick
import Caelestia.Config
import qs.components
import qs.components.effects
import qs.services

// Frosted surface shared by every floating element on the lock screen:
// translucent container, hairline edge highlight and a soft drop shadow
StyledRect {
    id: root

    property int elevation: 2
    property color edgeColour: Qt.alpha(Colours.palette.m3outlineVariant, 0.35)

    radius: Tokens.rounding.extraLarge
    color: Colours.tPalette.m3surfaceContainer
    border.width: 1
    border.color: edgeColour

    Behavior on border.color {
        CAnim {}
    }

    Elevation {
        z: -1
        anchors.fill: parent
        radius: parent.radius
        level: root.elevation
    }
}
