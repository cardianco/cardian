import QtQuick 2.15

import cardian 0.1
import veqtor 0.1

Expandable {
    id: control

    title: qsTr('seats')
    icon.text: '\ue178'

    contentItem: Item {
        visible: 50 < control.height
        implicitHeight: childrenRect.height + 20

        Veqtor {
            x: (control.availableWidth - width)/2
            width: 160; height: 130

//            rotation: 90
            src: 'qrc:/resources/images/seats.svg'

            onSvgLoaded: {
                document.frontLeft;
                document.frontRight;
                document.rearLeft;
                document.rearRight;
                document.rearCenter;
            }
        }
    }
}
