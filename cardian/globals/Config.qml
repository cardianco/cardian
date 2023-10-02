pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15

import QtPositioning 5.15

import Qt.labs.settings 1.1

import cardian.core 0.1

Control {
    id: control

    property string api: "http://cardian.ir/graphql.php"
    property string token: "" // Session token (note: user token can be user's password sha256)
    property string mapToken: ""
    property bool backAnimation
    property bool indicators
    property int selectedMap: -1
    property int processing: 0

    Settings {
        category: "Configuration/General"
        fileName: "config.ini"

        property alias api: control.api
        property alias token: control.token
        property alias mapToken: control.mapToken
        property alias backAnimation: control.backAnimation
        property alias indicators: control.indicators
    }
}
