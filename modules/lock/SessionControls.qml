pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia.Config
import Caelestia.Services
import qs.components.controls
import qs.services

RowLayout {
    id: root

    spacing: Tokens.spacing.small

    SessionButton {
        icon: Config.session.icons.logout
        command: Config.session.commands.logout
    }

    SessionButton {
        icon: Config.session.icons.shutdown
        command: Config.session.commands.shutdown
    }

    SessionButton {
        icon: Config.session.icons.hibernate
        command: Config.session.commands.hibernate
    }

    SessionButton {
        icon: Config.session.icons.reboot
        command: Config.session.commands.reboot
    }

    component SessionButton: IconButton {
        required property list<string> command

        function exec(): void {
            if (!SessionManager.exec(command))
                Quickshell.execDetached(command);
        }

        Layout.fillWidth: true

        padding: Tokens.padding.medium
        inactiveColour: Colours.tPalette.m3surfaceContainer
        inactiveOnColour: Colours.palette.m3onSurface
        radius: pressed ? Tokens.rounding.medium : Tokens.rounding.extraLarge
        font: Tokens.font.icon.large
        onClicked: exec()
    }
}
