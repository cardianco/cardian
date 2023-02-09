import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1
import cardian 0.1

Control {
    id: control

    property real value: 1
    readonly property real boundedValue: Math.min(Math.max(value, 0), 1);

    topPadding: 5

    contentItem: Grid {
        horizontalItemAlignment: Grid.AlignHCenter
        spacing: 2
        Text {
            font: Qomponent.font(Fonts.icon, {pointSize: 11})
            color: control.palette.windowText
            text: String.fromCharCode(0xe040 + Math.round(control.boundedValue * 10))
        }

        Text {
            text: (control.boundedValue * 100).toFixed()
            color: control.palette.windowText
            font: Fonts.subscript
            opacity: 0.8
        }
    }
}
