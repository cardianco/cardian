import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import cardian 0.1
import veqtor 0.1

Expandable {
    id: control

    property rect viewBox: Qt.rect(0, 0, 450, 280)
    property alias lightsMode: tabbar.currentIndex

    title: qsTr('lights')
    icon.text: '\ue170'
    desc.text: [qsTr('Lights are off'), qsTr('High beam lights are on'),
                qsTr('Low beam lights are on')][lightsMode]

    expandHeight: 170

    QtObject {
        id: colors
        readonly property color button: palette.button
        readonly property color text: palette.text
    }

    contentData: Item {
        width: control.width
        height: control.height
        visible: control.height > 50

        TabBar {
            id: tabbar
            x: (parent.width - width)/2
            z: 2
            topPadding: footer.height

            Repeater {
                /// TODO: Add 'Side'(\ue174), 'Control'(\ue171), and 'Fog'(\u????).
                model: ['\ue173','\ue170','\ue172']
                TabButton {
                    font: Fonts.icon
                    text: modelData
                    width: implicitWidth
                }
            }
        }

        Veqtor {
            x: (control.width - width)/2
            opacity: (control.height - 50) / 50

            height: control.expandHeight - 10
            src: 'qrc:/resources/images/mazda-6-2019.svg'

            onSvgLoaded: {
                root.viewBox = Qt.binding(() => viewBox);
                document.frLight.stroke = Qt.binding(()   => lightsMode ? colors.text : colors.button);
                document.frLightx.opacity = Qt.binding(() => lightsMode === 1);
                document.frLighty.opacity = Qt.binding(() => lightsMode === 2);

                document.flLight.stroke = Qt.binding(()   => lightsMode ? colors.text : colors.button);
                document.flLightx.opacity = Qt.binding(() => lightsMode === 1);
                document.flLighty.opacity = Qt.binding(() => lightsMode === 2);

                ['frLightx','frLighty',
                 'flLightx','flLighty'].forEach(id => document[id].strokeWidth = 0);
            }
        }
    }
}
