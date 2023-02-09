import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

BasePage {
    id: page

    component Head: Label {
        font: Fonts.head
        opacity: 0.5
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
            Grid {
                flow: page.vertical ? Grid.TopToBottom : Grid.LeftToRight
                spacing: 5

                LabledInput {
                    label.text: 'map token'
                    input.text: Config.mapToken
                    width: page.width/parent.children.length - parent.spacing/2
                }

                LabledInput {
                    label.text: 'token'
                    width: page.width/parent.children.length - parent.spacing/2
                }
            }

            Grid {
                Head {
                    text: 'Fonts'
                }
            }
        }
    }
}
