import QtQuick 2.15
import QtQuick.Controls 2.15

import cardian 0.1
import veqtor 0.1

Expandable {
    id: control

    title: 'seats'
    icon.text: '\ue178'

    expandHeight: contentHeight + implicitFooterHeight + implicitHeaderHeight

    contentData: Column {
        padding: 5
        topPadding: 15
        spacing: 10
        visible: control.height > 50

        Veqtor {
            x: (control.availableWidth - width)/2
            width: 160; height: 130

            rotation: 90
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
