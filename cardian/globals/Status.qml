pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

Control {
    id: control

    enum ST {
        Off, On,
        Unavalible, Avalible,
        Disable, Enable,
        Lock, UnLock,
        Close, Open,
        Damaged
    }

    property var doors: Object.seal(new Array(4).fill(false))
    property int lock: 0 //Status.UnLock
    property int updown: 0
    property int network: 0 //Status.On
    property int gps: 0 //Status.Off
    property int alarm: 0 //Status.Enable
    property int bluetooth: 0 //Status.Off
    property int engine: 0 //Status.Off
    property int fuel: 0

    property int temperature: 0

    property bool processing: false

    property real lastUpdate: 0
    property real carBattery: 0

    property point coordinate: Qt.point(0,0)

    Settings {
        category: "Configuration/Status"
        fileName: "config.ini"

        property alias lastUpdate: control.lastUpdate
        property alias coordinate: control.coordinate
    }
}
