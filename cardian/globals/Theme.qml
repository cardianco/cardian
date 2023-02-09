pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

Control {
    id: control

    Settings {
        category: "Theme"
        fileName: "config.ini"
    }
}
