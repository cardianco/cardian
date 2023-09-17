import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

Control {
    id: control
    width: 45

    property alias plus: top
    property alias minus: bottom

    contentItem: QGrid {
        vertical: true
        ToolButton { id: top; width: parent.width; height: width; flat: true }
        GridSeparator { color: control.palette.button; opacity: 1.0 }
        ToolButton { id: bottom; width: parent.width; height: width; flat: true }
    }

    background: Crystal {
        corners: Qt.vector4d(15,15,15,15)
    }
}
