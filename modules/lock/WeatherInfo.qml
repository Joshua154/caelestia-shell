import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.services

RowLayout {
    id: root

    spacing: Tokens.spacing.large

    Timer {
        running: true
        triggeredOnStart: true
        repeat: true
        interval: 900000 // 15 minutes
        onTriggered: Weather.reload()
    }

    MaterialIcon {
        animate: true
        text: Weather.icon
        color: Colours.palette.m3secondary
        fontStyle: Tokens.font.icon.builders.extraLarge.scale(1.4).build()
    }

    StyledText {
        animate: true
        text: Weather.temp
        color: Colours.palette.m3primary
        font: Tokens.font.headline.builders.large.weight(Font.DemiBold).width(80).build()
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 0

        StyledText {
            Layout.fillWidth: true
            animate: true
            text: Weather.description
            color: Colours.palette.m3onSurface
            font: Tokens.font.title.medium
            elide: Text.ElideRight
        }

        StyledText {
            Layout.fillWidth: true
            animate: true
            text: {
                const today = Weather.forecast[0];
                // TRANSLATORS: %1/%2 = today's max and min temperature, units already included
                return Tr.tr("High %1 • Low %2").arg(Weather.formatTemp(today?.maxTempC)).arg(Weather.formatTemp(today?.minTempC));
            }
            color: Colours.palette.m3onSurfaceVariant
            font: Tokens.font.body.medium
            elide: Text.ElideRight
        }
    }
}
