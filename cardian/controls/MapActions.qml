import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1

import cardian 0.1

Control {
    id: control

    property ToolButton ok: ToolBtn { text: '\ue007' }
    property ToolButton sync: ToolBtn { text: '\ue00b' }
    property ToolButton cancel: ToolBtn { text: 'x' }
    property ToolButton path: ToolBtn { text: '\ue195'; checkable: true }
    property ToolButton list: ToolBtn { text: '\ue19e'; checkable: true }

    property bool syncing: false

    component ToolBtn: ToolButton {
        padding: 5
        width: 25; height: width
        font: Fonts.icon

        background: Rectangle {
            color: Qomponent.alpha(border.color, 0.2)
            border.color: palette.button
            border.width: 1 + parent.checked
            opacity: 0.9 + 0.1 * !parent.down
            radius: 3
        }
    }

    NumberAnimation {
        running: control.syncing
        target: sync.contentItem
        property: 'rotation'
        duration: 1500; loops: -1
        from:360; to: 0
        alwaysRunToEnd: true
        easing.type: Easing.InOutCirc
    }

    contentItem: QGrid {
        spacing: 3
        verticalItemAlignment: Qt.AlignVCenter

        children: [ok, path, sync, list, cancel]
    }
}
