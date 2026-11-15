import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.controls
import qs.components.widgets
import qs.services

GlassCard {
    id: root

    property real progress: {
        const active = Players.active;
        return active?.length ? (active.position % active.length) / active.length : 0;
    }

    implicitWidth: layout.implicitWidth + Tokens.padding.large * 2
    implicitHeight: layout.implicitHeight + Tokens.padding.large * 2

    Behavior on progress {
        Anim {
            type: Anim.StandardLarge
        }
    }

    Timer {
        running: Players.active?.isPlaying ?? false
        interval: GlobalConfig.dashboard.mediaUpdateInterval
        triggeredOnStart: true
        repeat: true
        onTriggered: Players.active?.positionChanged()
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: Tokens.padding.large
        spacing: Tokens.spacing.medium

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.large

            CoverArt {
                implicitWidth: TokenConfig.sizes.notifs.image
                implicitHeight: TokenConfig.sizes.notifs.image
            }

            ColumnLayout {
                id: details

                Layout.fillWidth: true
                spacing: Tokens.spacing.extraSmall / 2

                StyledText {
                    animate: true
                    text: Players.active?.isPlaying ? Tr.tr("Now playing") : Tr.tr("Paused")
                    color: Colours.palette.m3primary
                    font: Tokens.font.label.builders.small.weight(Font.Medium).letterSpacing(2, true).capitalisation(Font.AllUppercase).build()
                }

                StyledText {
                    Layout.fillWidth: true
                    animate: true
                    text: (Players.active?.trackTitle ?? Tr.tr("Nothing playing")) || Tr.tr("Unknown track")
                    color: Colours.palette.m3onSurface
                    font: Tokens.font.body.builders.large.weight(Font.Medium).build()
                    elide: Text.ElideRight
                }

                StyledText {
                    Layout.fillWidth: true
                    animate: true
                    text: (Players.active?.trackArtist ?? Tr.tr("Try playing some music!")) || Tr.tr("Unknown artist")
                    color: Colours.palette.m3onSurfaceVariant
                    font: Tokens.font.body.small
                    elide: Text.ElideRight
                }
            }

            IconButton {
                Layout.leftMargin: Tokens.spacing.small
                type: IconButton.Tonal
                isRound: true
                shapeMorph: true
                icon: Players.active?.isPlaying ? "pause" : "play_arrow"
                checked: Players.active?.isPlaying ?? false
                disabled: !Players.active?.canTogglePlaying
                onClicked: Players.active?.togglePlaying()
            }
        }

        // Hairline progress track
        Item {
            Layout.fillWidth: true
            implicitHeight: 3

            Rectangle {
                anchors.fill: parent
                radius: Tokens.rounding.full
                color: Qt.alpha(Colours.palette.m3outlineVariant, 0.5)
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Math.round(parent.width * root.progress)
                radius: Tokens.rounding.full
                color: Colours.palette.m3primary
            }
        }
    }
}
