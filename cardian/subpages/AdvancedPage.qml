import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

BasePage {
    id: page

    font: Qomponent.font(Fonts.icon, {pointSize: 12})

    component GridSep: GridSeparator {
        padding: 10
        contentItem{color: page.palette.button; opacity: 1}
    }

    component Expand: Expandable {
        label.font: Fonts.regular
        font: page.font
    }

    contentData: Flickable {
        width: page.width
        height: page.height
        contentWidth: grid.width
        contentHeight: grid.height
        flickableDirection: Flickable.VerticalFlick

        ScrollBar.vertical: ScrollBar {
            x: parent.width - width; width: active ? 8 : 5
            Behavior on width {NumberAnimation {}}
        }

        Grid {
            id: grid
            spacing: 8

            Expand {
                title: 'live location'
                icon.text: '\ue07a'
            }
            Expand {
                title: 'lights'
                icon.text: '\ue170'
                expandHeight: 150
            }
            Expand {
                title: 'seats'
                icon.text: '\ue178'
            }
            Expand {
                title: 'doors'
                icon.text: '\ue17e'
            }
            Expand {
                title: 'fuel'
                icon.text: '\ue141'
            }
            Expand {
                title: 'battery'
                icon.text: '\ue168'
            }
        }
    }
}
