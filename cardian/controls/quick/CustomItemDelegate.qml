import QtQuick 2.15
import QtQuick.Controls 2.15

ItemDelegate {
    id: control
    text: qsTr("ItemDelegate")

    property color color: Qt.rgba(0.2,0.3,0.1,1)

    contentItem: Text {
        rightPadding: control.spacing
        text: control.text
        font: control.font
        color: control.enabled ? (control.down ? Qt.darker(color) : color) : Qt.lighter(color)
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        color: control.down ? Qt.darker("#aaa") : "#aaa"

        Rectangle {
            width: parent.width
            height: 1
            color: control.down ? Qt.darker(color) : color
            anchors.bottom: parent.bottom
        }
    }
}
