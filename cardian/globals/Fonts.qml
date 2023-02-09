pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

Control {
    id: control

    property font icon: tools.fromJson(fonts.value("icon")) ?? Qt.font({family:cardian.name, pointSize: 18})
    property font head: tools.fromJson(fonts.value("head")) ??
                        Qt.font({family:carlito.name, pointSize: 15, bold: true, weight: Font.ExtraBold})
    property font mono: tools.fromJson(fonts.value("mono")) ?? Qt.font({family:courierCode.name, pointSize: 9})
    property font regular: tools.fromJson(fonts.value("regular")) ?? Qt.font({family:carlito.name, pointSize: 9})
    property font subscript: tools.fromJson(fonts.value("subscript")) ?? Qt.font({family:carlito.name, pointSize: 7})

    FontLoader { id: courierCode; source: "qrc:/resources/font/Courier Prime Code.ttf" }
    FontLoader { id: cardian; source: "qrc:/resources/font/cardian-icons.ttf" }
    FontLoader { id: carlito; source: "qrc:/resources/font/Carlito-Regular.ttf" }

    QtObject {
        id: tools
        // Initialize font from a json string.
        function fromJson(json) {
            try { return Qt.font(JSON.parse(json)); }
            catch(e) { return undefined; }
        }

        // This function filter only keys which have true value.
        function toJson(font) {
            const filtred = Object.keys(font).filter(k => !!font[k] && k !== "pixelSize")
                                             .reduce((obj, k) => { obj[k] = font[k]; return obj; }, {});
            return JSON.stringify(filtred ?? {});
        }
    }

    Settings {
        id: fonts
        category: "Fonts"
        fileName: "config.ini"

        property string icon //: tools.toJson(control.icon)
        property string head //: tools.toJson(control.head)
        property string mono //: tools.toJson(control.mono)
        property string regular //: tools.toJson(control.regular)
        property string subscript //: tools.toJson(control.subscript)
    }
}
