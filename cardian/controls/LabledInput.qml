import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

Control {
    id: control

    height: 25

    readonly property alias input: input
    readonly property alias label: label

    /// @signal canceled, Triggers on cancel clicked
    signal canceled();
    /// @signal accepted, Triggers on accept clicked
    signal accepted(string text);

    component ToolBtn: ToolButton {
        height: parent.height
        palette.buttonText: control.palette.button
        font: Qomponent.font(Fonts.icon, {pixelSize: 12})
    }

    QtObject {
        id: priv
        property string buffer: ''

        Component.onCompleted: buffer = input.text
    }

    contentItem: QGrid {
        rightPadding: 6
        leftPadding: 6
        spacing: 2

        Label {
            id: label
            rightPadding: 3
            height: parent.height
            font: Fonts.subscript
        }

        GridSeparator {
            color: control.palette.button
            thickness: 1
            opacity: 0.5
        }

        TextField {
            id: input
            padding: 0
            width: parent.width - 20 - label.width - (actionRow.width * actionRow.visible)

            opacity: activeFocus ? 1.0 : 0.7

            font: Fonts.regular
            height: parent.height

            selectByMouse: true
            background: null

            color: palette.text
            selectionColor: palette.button
            selectedTextColor: palette.light

            onAccepted: control.accepted(text);

            // This element prevents the text field from having its drag event stolen by the parent.
            DragHandler { target: null }
        }

        GridSeparator {
            color: control.palette.button
            visible: actionRow.visible
            opacity: 0.5
        }

        QGrid {
            id: actionRow
            spacing: 4
            height: parent.height

            visible: input.text !== priv.buffer
            verticalItemAlignment: Grid.AlignVCenter

            ToolBtn {
                text: '\ue000'
                palette.buttonText: control.palette.text
                onClicked: {
                    input.text = priv.buffer;
                    control.canceled();
                }
            }

            ToolBtn {
                text: '\ue008'
                onClicked: {
                    priv.buffer = input.text;
                    control.accepted(input.text);
                }
            }
        }
    }

    background: Crystal {
        color: 'transparent'
        corners: Qt.vector4d(5,5,5,5)
        opacity: 0.5
    }
}
