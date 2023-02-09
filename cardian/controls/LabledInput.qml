import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

Control {
    id: control
    property alias input: input
    property alias label: label

    height: 25

    contentItem: Row {
        Label {
            id: label
            opacity: 0.7
            padding: 6
            height: parent.height
            font: Fonts.subscript
        }
        GridSeparator { color: control.palette.button; vertical: false; opacity: 0.5 }
        TextField {
            id: input
            padding: 0
            opacity: activeFocus ? 1.0 : 0.7
            width: parent.width - label.width - 10
            height: parent.height
            font: Fonts.mono
            selectionColor: palette.windowText
            selectedTextColor: palette.window
            selectByMouse: true
            background: Item {}
        }
    }

    background: Crystal {
        color: 'transparent'
        corners: Qt.vector4d(5,5,5,5)
        opacity: 0.5
    }
}
