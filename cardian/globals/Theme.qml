pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

Item {
    id: control

    property alias dark: dark.palette
    property alias light: light.palette

    property Item rippleEffectItem
    property var window

    function change(newTheme) {
        if(rippleEffectItem && window) {
            rippleEffectItem.capture(() => window.palette = newTheme, 20);
        }
    }

    Control {
        id: dark;
        palette {
            base: '#333435'; text: '#c1c2c3'; button: '#0777a1'; buttonText: '#f1f2f3'
            window: '#121314'; windowText: '#f1f2f3'; highlight: '#004e8b'; highlightedText: '#121314'
        }
    }

    Control {
        id: light;
        palette {
            base: '#c1c2c3'; text: '#212223'; button: '#097fb7'; buttonText: '#005d7a'
            window: '#f1f2f3'; windowText: '#121314'; highlight: '#0f5e72'; highlightedText: '#121314'
        }
    }

    Settings {
        category: "Theme"
        fileName: "config.ini"
    }
}
