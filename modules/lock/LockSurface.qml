pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell.Wayland
import M3Shapes
import Caelestia.Config
import Caelestia.Multimedia
import Caelestia.State
import qs.components
import qs.services

WlSessionLockSurface {
    id: root

    required property WlSessionLock lock
    required property Pam pam

    readonly property alias unlocking: unlockAnim.running

    contentItem.Config.screen: screen.name
    contentItem.Tokens.screen: screen.name

    color: "transparent"

    Connections {
        function onUnlock(): void {
            initAnim.stop();
            unlockAnim.start();
        }

        target: root.lock
    }

    SequentialAnimation {
        id: unlockAnim

        ParallelAnimation {
            Anim {
                target: content
                property: "reveal"
                to: 0
                duration: Tokens.anim.durations.normal
                easing: Tokens.anim.standardAccel
            }
            Anim {
                target: content
                property: "opacity"
                to: 0
                type: Anim.StandardSmall
            }
            Anim {
                target: badge
                property: "scale"
                to: 1
                type: Anim.FastSpatial
            }
            Anim {
                target: badge
                property: "opacity"
                to: 1
                type: Anim.FastEffects
            }
            Anim {
                target: background
                property: "opacity"
                to: 0
                type: Anim.StandardLarge
            }
            SequentialAnimation {
                PauseAnimation {
                    duration: Tokens.anim.durations.expressiveFastSpatial
                }
                ParallelAnimation {
                    Anim {
                        target: badge
                        property: "scale"
                        to: 0
                        type: Anim.StandardSmall
                    }
                    Anim {
                        target: badge
                        property: "opacity"
                        to: 0
                        type: Anim.StandardSmall
                    }
                }
            }
        }
        PropertyAction {
            target: root.lock
            property: "locked"
            value: false
        }
    }

    ParallelAnimation {
        id: initAnim

        running: true

        Anim {
            target: background
            property: "opacity"
            to: 1
            type: Anim.StandardLarge
        }
        SequentialAnimation {
            ParallelAnimation {
                Anim {
                    target: badge
                    property: "scale"
                    to: 1
                    type: Anim.FastSpatial
                }
                Anim {
                    target: badge
                    property: "rotation"
                    to: 360
                    duration: Tokens.anim.durations.expressiveFastSpatial
                    easing: Tokens.anim.standardAccel
                }
            }
            ParallelAnimation {
                Anim {
                    target: badge
                    property: "scale"
                    to: 0
                    type: Anim.Standard
                }
                Anim {
                    target: badge
                    property: "opacity"
                    to: 0
                    type: Anim.DefaultEffects
                }
                Anim {
                    target: content
                    property: "opacity"
                    to: 1
                    type: Anim.DefaultEffects
                }
                Anim {
                    target: content
                    property: "reveal"
                    to: 1
                }
            }
        }
    }

    Item {
        id: background

        anchors.fill: parent
        opacity: 0

        Item {
            anchors.fill: parent

            layer.enabled: true
            layer.effect: MultiEffect {
                autoPaddingEnabled: false
                blurEnabled: true
                blur: 1
                blurMax: 64
                blurMultiplier: 1
            }

            Loader {
                anchors.fill: parent
                sourceComponent: Config.lock.useWallpaper ? wallpaperBackground : screencopyBackground
            }
        }

        // Scrim so the content stays legible on any wallpaper, heavier behind the clock
        Rectangle {
            anchors.fill: parent

            gradient: Gradient {
                orientation: Gradient.Horizontal

                GradientStop {
                    position: 0
                    color: Qt.alpha(Colours.palette.m3surface, 0.8)
                }
                GradientStop {
                    position: 1
                    color: Qt.alpha(Colours.palette.m3surface, 0.5)
                }
            }
        }
    }

    Component {
        id: screencopyBackground

        ScreencopyView {
            captureSource: root.screen
        }
    }

    Component {
        id: wallpaperBackground

        Visual {
            source: Wallpapers.current
            playing: PersistentState.wallpaperPlaying
        }
    }

    Content {
        id: content

        anchors.fill: parent
        visible: Config.lock.enabled

        lock: root
        opacity: 0
        reveal: 0
    }

    // Shown while locking and unlocking, in place of the content
    Item {
        id: badge

        anchors.centerIn: parent
        implicitWidth: badgeShape.implicitSize
        implicitHeight: badgeShape.implicitSize

        visible: Config.lock.enabled
        rotation: 180
        scale: 0

        MaterialShape {
            id: badgeShape

            anchors.centerIn: parent
            implicitSize: lockIcon.implicitHeight + Tokens.padding.extraLarge * 4
            shape: MaterialShape.Cookie12Sided
            color: Colours.palette.m3primaryContainer

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                blurMax: 15
                shadowColor: Qt.alpha(Colours.palette.m3shadow, 0.7)
            }
        }

        MaterialIcon {
            id: lockIcon

            anchors.centerIn: parent
            text: root.unlocking ? "lock_open" : "lock"
            color: Colours.palette.m3onPrimaryContainer
            fontStyle: Tokens.font.icon.builders.extraLarge.scale(3).weight(Font.Bold).build()
        }
    }
}
