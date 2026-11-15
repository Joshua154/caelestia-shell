pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia.Config
import Caelestia.Services
import qs.components.controls
import qs.services

GlassCard {
    id: root

    implicitWidth: layout.implicitWidth + Tokens.padding.small * 2
    implicitHeight: layout.implicitHeight + Tokens.padding.small * 2

    radius: Tokens.rounding.full

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Tokens.spacing.extraSmall

        SessionButton {
            icon: Config.session.icons.logout
            command: Config.session.commands.logout
        }

        SessionButton {
            icon: Config.session.icons.hibernate
            command: Config.session.commands.hibernate
        }

        SessionButton {
            icon: Config.session.icons.reboot
            command: Config.session.commands.reboot
        }

        SessionButton {
            icon: Config.session.icons.shutdown
            command: Config.session.commands.shutdown
        }
    }

    component SessionButton: IconButton {
        required property list<string> command

        function exec(): void {
            if (!SessionManager.exec(command))
                Quickshell.execDetached(command);
        }

        isRound: true
        shapeMorph: true
        padding: Tokens.padding.medium
        inactiveColour: "transparent"
        inactiveOnColour: Colours.palette.m3onSurfaceVariant
        font: Tokens.font.icon.medium
        onClicked: exec()
    }
}
