import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

BasePage {
    id: page

    component GSep: GridSeparator {
        color: page.palette.button
        thickness: 5; padding: 0
        opacity: .3
    }

    component Head: Label {
        color: page.palette.link
        font: Fonts.head
        opacity: 0.8
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
            spacing: 5

            Column {
                Head { text: 'API Tokens'; topPadding: 10 }
                Grid {
                    flow: page.vertical ? Grid.TopToBottom : Grid.LeftToRight
                    spacing: 5

                    LabledInput {
                        label.text: 'map token'
                        input.text: Config.mapToken
                        buttons.visible: input.text !== Config.mapToken
                        input.placeholderText: 'Enter MapGL token here'
                        width: page.vertical ? page.width : (page.width/2 - parent.spacing/2)
                        onAccept: Config.mapToken = text
                    }

                    LabledInput {
                        label.text: 'user token'
                        input.placeholderText: 'Enter user toke here'
                        width: page.vertical ? page.width : (page.width/2 - parent.spacing/2)
                        onAccept: Config.mapToken = text
                    }
                }
            }

            GSep{}
            Column {
                Head { text: 'Appreance'; }
                Row {
                    ToolButton {
                        id: darkmode
                        width: 25; height: 25
                        checkable: true
                        text: checked ? '\ue094' : '\ue095'
                        font: Qomponent.font(Fonts.icon, {pointSize: 13})
                        checked: Config.darkmode
                        onCheckedChanged: Config.darkmode = checked
                    }
                    Label {
                        height: parent.height
                        text: darkmode.checked ? "Dark mode" : "Light mode"
                    }
                }

                Head { text: 'Animations'; font.pointSize: 10 }
                CheckBox {
                    indicator { width: 21; height: 21 }
                    text: 'Background animation'
                    checked: Config.backAnimation
                    onCheckedChanged: Config.backAnimation = checked
                }

                Head { text: 'Main Page'; font.pointSize: 10 }
                CheckBox {
                    indicator { width: 21; height: 21 }
                    text: 'Expanded indicators'
                    checked: Config.indicators
                    onCheckedChanged: Config.indicators = checked
                }
            }

            GSep{}
        }
    }
}
