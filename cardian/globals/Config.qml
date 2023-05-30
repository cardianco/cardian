pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

Control {
    id: control

    property string token: ""
    property string mapToken: 'pk.eyJ1Ijoic21yNzYiLCJhIjoiY2t3dzVtN2ZvMDBmeDJ2bGFqcGR5em1leiJ9.SpNKEOM_dOgZyLTv154K_A'
    property bool backAnimation;
    property bool indicators;
    property bool darkmode;

    Settings {
        category: "Configuration/General"
        fileName: "config.ini"

        property alias token: control.token
        property alias mapToken: control.mapToken
        property alias backAnimation: control.backAnimation
        property alias indicators: control.indicators
        property alias darkmode: control.darkmode
    }
}
