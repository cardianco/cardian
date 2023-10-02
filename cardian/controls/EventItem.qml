import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1 // Array.qat, VRow, font
import cardian 0.1

AbstractButton {
    id: control

    property int index: NaN
    property int priority: 0
    property real timestamp: NaN
    property bool expanded: false
    property string recordId: '-'

    property alias desc: description

    QtObject {
        id: priv
        readonly property var colors: [control.palette.button, '#f35', '#fd1']
        property real elapsed: Date.now() - timestamp * 1000
        property color color: colors[priority]
    }

    Timer {
        running: true
        /// This line defines the update interval of elapsed time, which depends on the elapsed time.
        interval: [1e3, 6e4, 36e4].filter(v => v < priv.elapsed).qat(-1) ?? 1000;
        onTriggered: {
            priv.elapsed = Date.now() - timestamp * 1000;
        }
    }

    contentItem: Column {
        Control {
            padding: 5

            width: parent.width
            contentItem: VRow {
                Row {
                    spacing: 5
                    Label { opacity: 0.8; text: control.index }
                    Label {
                        y: 5
                        font: Fonts.subscript; opacity: 0.8
                        text: control.recordId
                    }
                    Rectangle { width: 1; height: parent.height; opacity: 0.3 }
                    Label { text: control.text }
                    Label {
                        topPadding: 5
                        text: Scripts.readableTime(priv.elapsed).join(' ') + qsTr(' ago')
                        font: Fonts.subscript
                    }
                }

                Label {
                    text: '+'
                    font: Fonts.icon
                    rotation: expanded * -45
                    Behavior on rotation {SmoothedAnimation{}}
                }

                TapHandler { margin: 5; onTapped: expanded ^= true; }
            }

            background: Rectangle {
                color: priv.color
                opacity: 0.2
            }
        }

        Column {
            padding: 5
            visible: expanded

            Label {
                id: description
                text: ''
                opacity: 0.8
                font: Fonts.mono
            }

            Row {}
        }
    }

    background: Rectangle {
        border.color: priv.color
        radius: 3; opacity: 0.7
        color: 'transparent'
    }
}
