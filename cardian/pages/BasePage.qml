import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: control
    property real oriention: Qt.Vertical
    readonly property bool vertical: oriention == Qt.Vertical
    background.opacity: 0.3
}
