pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1
import Qomponent 0.1

Item {
    id: control

    property alias dark: dark.palette
    property alias light: light.palette
    property string active: 'dark'
    property SystemPalette system: SystemPalette { colorGroup: SystemPalette.Active }

    property Item rippleEffectItem: RippleTT {
        width: (parent ?? {}).width
        height: (parent ?? {}).height
        duration: 800
    }

    function change(theme) {
        rippleEffectItem.capture(() => control.active = theme, 20);
    }

    Control {
        id: dark
        palette {
            alternateBase: '#0777a1';
            base: '#333435'; text: '#c1c2c3'
            button: '#0777a1'; buttonText: '#f1f2f3'
            window: '#121314'; windowText: '#f1f2f3'
            highlight: '#004e8b'; highlightedText: '#121314'
        }
    }

    Control {
        id: light
        palette {
            alternateBase: '#097fb7';
            base: '#c1c2c3'; text: '#121314'
            button: '#097fb7'; buttonText: '#4e6ccd'
            window: '#f1f2f3'; windowText: '#121314'
            highlight: '#2a90ef'; highlightedText: '#f1f2f3'
        }
    }

    Settings {
        category: "Theme"
        fileName: "config.ini"
        property alias active: control.active
    }
}
