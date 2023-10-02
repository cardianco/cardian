import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

Control {
    id: control
    padding: 5

    property int oriention: Qt.Vertical
    property bool expanded: false
    readonly property bool vertical: oriention == Qt.Vertical

    component DataIcon: QGrid {
        readonly property alias label: label
        readonly property alias value: value
        visible: expanded
        vertical: true
        Label { id: label; font: control.font }
        Label { id: value; font: Fonts.subscript }
    }

    component GridSep: GridSeparator { padding: 2; visible: expanded }

    font: Fonts.icon

    contentItem: VRow {
        Control {
            width: 20
            height: implicitContentHeight + 8
            clip: true
            palette.text: control.palette.buttonText

            Behavior on height {SmoothedAnimation{}}

            contentItem: QGrid {
                spacing: 4
                vertical: true

                BatteryIndicator {
                    value: Status.battery
                }
                GridSep {}
                DataIcon {
                    visible: expanded
                    label.text: ['\ue061','\ue063','\ue065'][Number(Status.lock)]
                }
                GridSep {}
                DataIcon {
                    label.text: ['\ue141', '\ue143'][Number(Status.fuel < 1)]
                    value.text: Status.fuel
                }
                GridSep {}
                DataIcon {
                    visible: expanded
                    label.text: ['\ue037','\ue036'][Number(Status.alarm)]
                }
                GridSep {}
                DataIcon {
                    label.text: ['\ue145','\ue144'][Number(Status.engine)]
                    value.text: ['off','on'][Number(Status.engine)]
                }
                Item {width: parent.width; height: 1}
            }

            background: Crystal {
                corners: control.vertical ? Qt.vector4d(2,2,18,2) : Qt.vector4d(2,2,18,18)
            }
        }

        Control {
            width: 20
            height: implicitContentHeight + 8
            clip: true
            palette.text: control.palette.buttonText

            Behavior on height {SmoothedAnimation{}}

            contentItem: QGrid {
                spacing: 4
                vertical: true
                verticalItemAlignment: Grid.AlignVCenter

                DataIcon {
                    topPadding: 4
                    label.text: '\ue08b'
                    value.text: Status.updown
                }
                GridSep {visible: true}
                DataIcon {
                    label.text: ['\ue086','\ue084'][Number(Status.gps)]
                }
                GridSep {}
                DataIcon {
                    label.text: ['\ue033','\ue031'][Number(Status.bluetooth)]
                }
                GridSep {}
                DataIcon {
                    visible: true
                    label.text: '\ue148'
                    value.text: Status.temperature
                }
                GridSep { visible: Config.processing }
                BusyIndicator {
                    width: 12; height: 12
                    running: Config.processing
                }
                Item {width: parent.width; height: 1}
            }

            background: Crystal {
                corners: control.vertical ? Qt.vector4d(2,2,2,18) : Qt.vector4d(2,2,18,18)
            }
        }
    }
}
