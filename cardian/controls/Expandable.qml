import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1

Page {
    id: control

    property alias icon: icon
    property alias label: label
    property real expandHeight: 90
    readonly property bool expanded: btn.checked

    width: page.availableWidth
    height: expanded ? expandHeight : header.height + footer.height

    Behavior on height {SmoothedAnimation {}}

    header: Row {
        padding: 5; spacing: 5
        Label {
            id: icon
            font: control.font
            opacity: 0.5
        }
        Label {
            id: label
            opacity: 0.5
            text: control.title
        }
    }

    footer: ToolButton {
        id: btn
        height: 15
        checkable: true
        text: checked ? '\ue133' : '\ue134'
        font: control.font
        opacity: 0.6
        background: Rectangle {
            color: Qomponent.alpha(palette.button, btn.checked ? 0 : 0.2)
            Rectangle {
                y: parent.height - 1
                width: parent.width; height: 1
                color: palette.button
            }
        }
    }
}
