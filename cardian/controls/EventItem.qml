import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1 // Array.qat, VRow, font
import cardian 0.1

Control {
    id: control

    property real num: 0
    property real timestamp: 0
    property bool expanded: false
    property int type: EventItem.Type.Info

    property alias title: title
    property alias desc: description

    enum Type { Info, Error, Warning }

    QtObject {
        id: internals
        readonly property var colors: [palette.button, '#f35', '#fd1']
        property real elapsed: Date.now() - timestamp * 1000

    }

    Timer {
        running: true
        /// This line defines the update interval of elapsed time, which depends on the elapsed time.
        interval: [1e3, 6e4, 36e4].filter(v => v < internals.elapsed).qat(-1) ?? 1000;
        onTriggered: {
            internals.elapsed = Date.now() - timestamp * 1000;
        }
    }


    contentItem: Column {
        Control {
            padding: 5
            width: parent.width
            contentItem: VRow {
                Row {
                    spacing: 5
                    Label { text: control.num; opacity: 0.8 }
                    Rectangle { width: 1; height: parent.height; opacity: 0.3 }
                    Label { id: title }
                    Label {
                        topPadding: 5
                        text: Scripts.readableTime(internals.elapsed).join(' ') + ' ago'
                        font: Fonts.subscript
                    }
                }

                Label {
                    text: '+'
                    font: Qomponent.font(Fonts.icon, {pointSize: 10})
                    rotation: expanded * -45
                    Behavior on rotation {SmoothedAnimation{}}
                }
                TapHandler {
                    margin: 5
                    onTapped: expanded ^= true;
                }
            }
            background: Rectangle {
                color: internals.colors[type]
                opacity: 0.2
            }
        }

        Column {
            padding: 5
            visible: expanded

            Label {
                id: description
                text: ''; opacity: 0.8
            }

            Row {}
        }
    }

    background: Rectangle {
        border.color: internals.colors[type]
        radius: 3; opacity: 0.7
        color: 'transparent'
    }
}
