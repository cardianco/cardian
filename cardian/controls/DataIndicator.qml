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

    component DataIcon: Grid {
        readonly property alias label: label
        readonly property alias value: value
        visible: expanded
        horizontalItemAlignment: Grid.AlignHCenter
        Label { id: label; font: control.font }
        Label { id: value; font: Fonts.subscript }
    }

    component GridSep: GridSeparator { padding: 2; visible: expanded }

    font: {font = Fonts.icon; font.pointSize = 11}

    contentItem: VRow {
        Control {
            width: 20
            height: implicitContentHeight + 8
            clip: true
            palette.windowText: control.palette.buttonText

            Behavior on height {SmoothedAnimation{}}

            contentItem: Grid {
                spacing: 4
                horizontalItemAlignment: Grid.AlignHCenter
                verticalItemAlignment: Grid.AlignVCenter

                BatteryIndicator { }
                GridSep {}
                Label {
                    visible: expanded
                    text: ['\ue061','\ue063','\ue065'][Status.lock]
                    font: control.font
                }
                GridSep {}
                DataIcon {
                    label.text: ['\ue143','\ue141'][Status.fuel]
                    value.text: '0'
                }
                GridSep {}
                Label {
                    visible: expanded
                    text: ['\ue037','\ue036'][Status.alarm]
                    font: control.font
                }
                GridSep {}
                DataIcon {
                    label.text: ['\ue145','\ue144'][Status.engine]
                    value.text: ['off','on'][Status.engine]
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
            palette.windowText: control.palette.buttonText

            Behavior on height {SmoothedAnimation{}}

            contentItem: Grid {
                spacing: 4
                horizontalItemAlignment: Grid.AlignHCenter
                verticalItemAlignment: Grid.AlignVCenter

                DataIcon {
                    topPadding: 4
                    label.text: '\ue08b'
                    value.text: Status.updown
                }
                GridSep {visible: true}
                DataIcon {
                    label.text: ['\ue084','\ue084'][Status.gps]
                }
                GridSep {}
                DataIcon {
                    label.text: ['\ue033','\ue031'][Status.bluetooth]
                }
                GridSep {}
                DataIcon {
                    visible: true
                    label.text: '\ue148'
                    value.text: Status.temperature
                }
                GridSep {}
                BusyIndicator {
                    width: 15; height: 15
                    running: Status.processing
                }
                Item {width: parent.width; height: 1}
            }

            background: Crystal {
                corners: control.vertical ? Qt.vector4d(2,2,2,18) : Qt.vector4d(2,2,18,18)
            }
        }
    }
}
