pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import Qomponent 0.1

Control {
    id: control

    property font icon: tools.getConfig('icon') ?? Qt.font({family:cardian.name, pixelSize: 14})
    property font head: tools.getConfig('head') ?? Qt.font({family:carlito.name, pixelSize: 19, bold: true, weight: Font.ExtraBold})
    property font mono: tools.getConfig('mono') ?? Qt.font({family:courierCode.name, pixelSize: 12})
    property font btnicon: tools.getConfig('btnicon') ?? Qt.font({family:cardian.name, pixelSize: 20})
    property font regular: tools.getConfig('regular') ?? Qt.font({family:carlito.name, pixelSize: 12})
    property font subscript: tools.getConfig('subscript') ?? Qt.font({family:carlito.name, pixelSize: 9})

    FontLoader { id: courierCode; source: "qrc:/resources/font/Courier Prime Code.ttf" }
    FontLoader { id: cardian; source: "qrc:/resources/font/cardian-icons.ttf" }
    FontLoader { id: carlito; source: "qrc:/resources/font/Carlito-Regular.ttf" }
    FontLoader { source: "qrc:/resources/font/Carlito-Bold.ttf" }

    QtObject {
        id: tools
        // Initialize font from a json string.
        function fromJson(json: string): font {
            try { return Qt.font(JSON.parse(json)); }
            catch(e) { return undefined; }
        }

        // This function filter only keys which have true value.
        function toJson(font: font): string {
            const filtred = Qomponent.qfilter(font, ['pointSize']);
            return JSON.stringify(filtred ?? {});
        }

        function getConfig(key: string): font {
            return tools.fromJson(settings.value(key));
        }
    }

    Settings {
        id: settings
        category: 'Fonts'
        fileName: 'config.ini'

        property string icon: tools.toJson(control.icon)
        property string head: tools.toJson(control.head)
        property string mono: tools.toJson(control.mono)
        property string btnicon: tools.toJson(control.btnicon)
        property string regular: tools.toJson(control.regular)
        property string subscript: tools.toJson(control.subscript)
    }
}
