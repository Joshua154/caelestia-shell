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

    readonly property real authScale: CUtils.clamp(heroScale, 0.85, 1.15)
    readonly property int hairlineWidth: Math.round(36 * authScale)
    readonly property color hairlineColour: Qt.alpha(Colours.palette.m3outline, 0.6)

    implicitWidth: layout.implicitWidth
    // Reserve room for two lines of messages so nothing shifts when they appear
    implicitHeight: layout.implicitHeight + stateMessage.anchors.topMargin + Math.ceil(messageMetrics.height * 2.4)

    ColumnLayout {
        id: layout

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        spacing: 0

        Clock {
            Layout.alignment: Qt.AlignHCenter
            heroScale: root.heroScale
        }

        // Date as a tracked-out small-caps label, flanked by hairlines
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Math.round(Tokens.spacing.medium * root.heroScale)
            spacing: Tokens.spacing.large

            Rectangle {
                implicitWidth: root.hairlineWidth
                implicitHeight: 1
                color: root.hairlineColour
            }

            StyledText {
                text: Time.format("dddd, d MMMM")
                color: Colours.palette.m3onSurfaceVariant
                font: Tokens.font.title.builders.medium.scale(root.authScale).weight(Font.Medium).letterSpacing(Math.round(3 * root.authScale), true).capitalisation(Font.AllUppercase).build()
            }

            Rectangle {
                implicitWidth: root.hairlineWidth
                implicitHeight: 1
                color: root.hairlineColour
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Math.round(Tokens.spacing.extraExtraLarge * root.heroScale)
            spacing: Tokens.spacing.medium

            ProfilePic {
                id: pfp

                size: passwordInput.implicitHeight
                active: root.lock.pam.fprint.active || root.lock.pam.howdy.active
            }

            PasswordInput {
                id: passwordInput

                inputScale: root.authScale
                maxWidth: Math.min(root.width - pfp.width - parent.spacing, Tokens.sizes.lock.centerWidth * 0.6 * root.authScale)
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
        anchors.topMargin: Tokens.spacing.large

        pam: root.lock.pam
    }
}
