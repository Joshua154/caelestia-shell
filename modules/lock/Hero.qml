import QtQuick
import QtQuick.Layouts
import Caelestia
import Caelestia.Config
import qs.components
import qs.services
import qs.modules.lock.center

Item {
    id: root

    required property var lock
    required property real heroScale

    readonly property real authScale: CUtils.clamp(heroScale, 0.85, 1.2)

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight + layout.anchors.bottomMargin

    ColumnLayout {
        id: layout

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        // Reserve room for two lines of messages so the clock doesn't shift when they appear
        anchors.bottomMargin: Math.ceil(messageMetrics.height * 2.4) + stateMessage.anchors.topMargin

        spacing: 0

        Clock {
            heroScale: root.heroScale
        }

        StyledText {
            Layout.topMargin: Math.round(Tokens.spacing.extraLarge * root.heroScale)

            text: Time.format("dddd • d MMM").toUpperCase()
            color: Colours.palette.m3onSurface
            font: Tokens.font.title.builders.large.scale(root.authScale).weight(Font.DemiBold).build()
        }

        RowLayout {
            Layout.topMargin: Math.round(Tokens.spacing.extraExtraLarge * root.heroScale)
            spacing: Tokens.spacing.medium

            ProfilePic {
                size: passwordInput.implicitHeight
            }

            PasswordInput {
                id: passwordInput

                inputScale: root.authScale
                maxWidth: Math.min(root.width - x, Tokens.sizes.lock.centerWidth * 0.7 * root.authScale)
                lock: root.lock
            }
        }
    }

    FontMetrics {
        id: messageMetrics

        font: Tokens.font.body.small
    }

    StateMessage {
        id: stateMessage

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: layout.bottom
        anchors.topMargin: Tokens.spacing.medium

        pam: root.lock.pam
    }
}
