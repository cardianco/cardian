import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import Qomponent 0.1
import Hive 1.0

import cardian 0.1
import veqtor 0.1

ApplicationWindow {
    id: window

    width: 265
    height: 480

    minimumWidth: 200

    visible: true
    title: Application.name ?? qsTr("Cardian")

    palette: Theme.light

//    contentData: Extra {
//    contentData: Navigation {
    contentData: Main {
        width: window.width
        height: window.height
    }

    RippleTT {
        width: window.width
        height: window.height
        source: window.contentItem
        duration: 800
        Component.onCompleted: {
            Theme.rippleEffectItem = this;
            Theme.window = window;
        }
    }

    SystemTrayIcon {
        id: systemTray
//        visible: true
//        icon.source: "qrc:/resources/icons/icon.svg"

        onActivated: {
            if(reason === SystemTrayIcon.Trigger) {
                window.visible = true;
                window.show();
            }
        }

        menu: Menu {
            MenuItem {
                text: window.visible ? qsTr("Hide") : qsTr("Show")
                onTriggered: window.visible = !window.visible;
            }

            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit();
            }
        }
    }
}
