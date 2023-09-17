import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

Control {
    id: control

    readonly property alias input: input
    readonly property alias label: label
    readonly property alias buttons: buttons

    //
    signal cancel()
    //
    signal accept(string text)

    height: 25

    contentItem: QGrid {
        Label {
            id: label
            opacity: 0.7
            rightPadding: 6
            leftPadding: 6
            height: parent.height
            font: Fonts.subscript
        }
        GridSeparator { color: control.palette.button; opacity: 0.5 }
        TextField {
            id: input
            rightPadding: 6
            opacity: activeFocus ? 1.0 : 0.7
            width: parent.width - label.width - buttons.width
            height: parent.height
            font: Fonts.mono
            selectionColor: palette.windowText
            selectedTextColor: palette.window
            selectByMouse: true
            background: Item {}

            // This element prevents the text field from having its drag event stolen by the parent.
            DragHandler { target: null }
        }
        GridSeparator { color: control.palette.button; opacity: 0.5; visible: buttons.visible }
        QGrid {
            id: buttons
            spacing: 2
            leftPadding: 4; rightPadding: 4
            height: parent.height

            flow: Grid.LeftToRight
            verticalItemAlignment: Grid.AlignVCenter

            visible: false

            ToolButton {
                height: parent.height
                text: '\ue000'
                visible: parent.visible
                palette.buttonText: control.palette.button
                font: Qomponent.font(Fonts.icon, {pointSize: 9})
                onClicked: control.cancel()
            }

            ToolButton {
                height: parent.height
                text: '\ue008'
                font: Qomponent.font(Fonts.icon, {pointSize: 9})
                visible: parent.visible
                onClicked: control.accept(input.text)
            }
        }
    }

    background: Crystal {
        color: 'transparent'
        corners: Qt.vector4d(5,5,5,5)
        opacity: 0.5
    }
}
