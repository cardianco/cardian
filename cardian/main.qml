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

    visible: true
    title: qsTr("Cardian")

    palette {
        button: '#0777a1'
        buttonText: '#f1f2f3'

        window: '#121314'
        windowText: '#eee'
        text: '#eee'

        highlight: '#0759a1'
        highlightedText: '#fff'
    }

    contentData: Main {
//    contentData: Home {
//    contentData: Extra {
//    contentData: Navigation {
//    contentData: Item {
        width: window.width
        height: window.height
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
