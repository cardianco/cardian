import QtQuick 2.15

QtObject {
    property real min
    property real max
    readonly property real dist: Math.abs(min - max)
}
