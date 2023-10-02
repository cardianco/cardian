import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1
import cardian 0.1

Control {
    id: control

    property real value: 1
    readonly property real boundedValue: Math.min(Math.max(value, 0), 1);

    topPadding: 5

    contentItem: QGrid {
        vertical: true
        spacing: 2
        Label {
            font: Qomponent.font(Fonts.icon, {pixelSize: 14})
            text: String.fromCharCode(0xe040 + Math.round(control.boundedValue * 10))
        }

        Label {
            text: (control.boundedValue * 100).toFixed()
            font: Fonts.subscript
            opacity: 0.8
        }
    }
}
