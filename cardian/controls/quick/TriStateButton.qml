import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0

HexagonButton {
    id: control

    enum States { None, Checked, Indeterminate }

    state: TriStateButton.None

    Hexagon {
        ScaleAnimator on scale {
            from: 0; to: 1; duration: 1000; loops: -1
            easing.type: Easing.OutCubic
            running: control.state == TriStateButton.Indeterminate
        }
        OpacityAnimator on opacity {
            from: 0.7; to: 0.1; duration: 1000; loops: -1
            easing.type: Easing.OutCubic
            running: control.state == TriStateButton.Indeterminate
        }

        visible: control.state == TriStateButton.Indeterminate

        implicitWidth: control.width
        implicitHeight: implicitWidth * 0.85106
        radius: 5; opacity: 0.3
        color: {
            const  _color =  control.highlighted ? palette.highlight : palette.button
            control.down ? Qt.lighter(_color, 1.1) : _color
        }
    }

    background: Hexagon {
        visible: control.enabled

        implicitWidth: 65
        implicitHeight: implicitWidth * 0.85106

        radius: 5
        strokeWidth: control.flat ? 0 : 1

        color: Hive.alpha(strokeColor, control.down ? 0.1 : 0.2)
        strokeColor: {
            const  _color =  control.highlighted ? palette.highlight : palette.button
            control.down ? Qt.lighter(_color, 1.1) : _color
        }

        Hexagon {
            x: (parent.width  - width + 1)/2
            y: (parent.height - height)/2

            width: parent.width - (visible ? 6 : 0)
            height: parent.height - (visible ? 6 : 0)
            visible: control.checked || control.state == TriStateButton.Checked

            color: 'transparent'
            strokeColor: parent.strokeColor
            strokeWidth: 1
            radius: 3

            Behavior on width { NumberAnimation { duration: 100 }}
            Behavior on height { NumberAnimation { duration: 100 }}
        }
    }
}
