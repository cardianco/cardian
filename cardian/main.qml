import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import cardian 0.1 /// JsUtils
import cardian.core 0.1
import Hive 1.0

import 'cardian/controls'

ApplicationWindow {
    id: window

    width: 270
    height: 500

    minimumWidth: 200

    visible: true
    visibility: Qt.platform.os == "android" ? Window.FullScreen : Window.AutomaticVisibility
    title: Application.name ?? qsTr("Cardian")

    palette: Theme[Theme.active]

    // contentData: Control { id: control
    contentData: Main {
        width: window.width
        height: window.height
    }

    Component.onCompleted: {
        Theme.rippleEffectItem.parent = window.contentItem;
        Theme.rippleEffectItem.source = window.contentItem;
    }

    SystemTrayIcon {
        id: systemTray
        visible: Qt.platform.os !== "android"
        icon.source: 0.5 > Theme.system.text.hslLightness ? 'qrc:/resources/logo-light.svg' :
                                                      'qrc:/resources/logo-dark.svg'

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
