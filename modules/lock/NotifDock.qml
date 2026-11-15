pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.containers
import qs.components.effects
import qs.services

Item {
    id: root

    required property var lock
    // Vertical room the dock may take up, pill included
    required property real maxHeight

    readonly property int count: Notifs.list.length
    readonly property bool canExpand: count > 0 && !Config.lock.hideNotifs
    property bool expanded

    implicitHeight: pill.implicitHeight + panel.height + (panel.height > 0 ? panel.anchors.bottomMargin : 0)
    visible: count > 0

    onCanExpandChanged: {
        if (!canExpand)
            expanded = false;
    }

    Elevation {
        anchors.fill: panel
        radius: panel.radius
        level: 2
        visible: panel.height > 0
    }

    ClipRect {
        id: panel

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: pill.top
        anchors.bottomMargin: Tokens.spacing.medium

        height: root.expanded ? Math.max(0, Math.min(list.contentHeight + list.anchors.margins * 2, root.maxHeight - pill.implicitHeight - anchors.bottomMargin)) : 0
        radius: Tokens.rounding.extraLarge
        color: Colours.tPalette.m3surfaceContainer

        Behavior on height {
            Anim {}
        }

        StyledListView {
            id: list

            anchors.fill: parent
            anchors.margins: Tokens.padding.medium

            spacing: Tokens.spacing.small
            clip: true

            model: ScriptModel {
                values: {
                    const list = Notifs.notClosed.map(n => [n.appName, null]);
                    return [...new Map(list).keys()];
                }
            }

            delegate: NotifGroup {}

            add: Transition {
                Anim {
                    type: Anim.DefaultEffects
                    property: "opacity"
                    from: 0
                    to: 1
                }
                Anim {
                    property: "scale"
                    from: 0
                    to: 1
                }
            }

            remove: Transition {
                Anim {
                    type: Anim.DefaultEffects
                    property: "opacity"
                    to: 0
                }
                Anim {
                    property: "scale"
                    to: 0.6
                }
            }

            move: Transition {
                Anim {
                    type: Anim.DefaultEffects
                    properties: "opacity,scale"
                    to: 1
                }
                Anim {
                    property: "y"
                }
            }

            displaced: Transition {
                Anim {
                    type: Anim.DefaultEffects
                    properties: "opacity,scale"
                    to: 1
                }
                Anim {
                    property: "y"
                }
            }
        }
    }

    // Hairline frame for the expanded panel
    Rectangle {
        anchors.fill: panel
        radius: panel.radius
        color: "transparent"
        border.width: 1
        border.color: Qt.alpha(Colours.palette.m3outlineVariant, 0.35)
        visible: panel.height > 0
    }

    GlassCard {
        id: pill

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        implicitWidth: pillLayout.implicitWidth + Tokens.padding.large * 2
        implicitHeight: pillLayout.implicitHeight + Tokens.padding.medium * 2

        radius: Tokens.rounding.full

        StateLayer {
            radius: parent.radius
            disabled: !root.canExpand
            onClicked: root.expanded = !root.expanded
        }

        RowLayout {
            id: pillLayout

            anchors.centerIn: parent
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: "notifications"
                color: Colours.palette.m3onSurfaceVariant
                fill: 1
            }

            StyledText {
                animate: true
                text: Config.lock.hideNotifs ? Tr.tr("Unlock for notifications") : Tr.trN("%n notification", "%n notifications", root.count)
                color: Colours.palette.m3onSurface
                font: Tokens.font.body.medium
            }

            MaterialIcon {
                visible: root.canExpand
                text: "expand_less"
                color: Colours.palette.m3onSurfaceVariant
                rotation: root.expanded ? 180 : 0

                Behavior on rotation {
                    Anim {}
                }
            }
        }
    }
}
