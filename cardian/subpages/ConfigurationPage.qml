import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

BasePage {
    id: page

    component GSep: GridSeparator {
        color: page.palette.button
        thickness: 5; padding: 0
        opacity: 0.3
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

        QGrid {
            id: grid
            vertical: true
            horizontalItemAlignment: Grid.AlignLeft
            spacing: 5

            Column {
                Head { text: qsTr('API Tokens'); topPadding: 10 }
                QGrid {
                    vertical: page.vertical
                    spacing: 5

                    LabledInput {
                        label.text: qsTr('map token')
                        input.text: Config.mapToken
                        buttons.visible: input.text !== Config.mapToken
                        input.placeholderText: qsTr('Enter MapGL token here')
                        width: page.vertical ? page.width : (page.width/2 - parent.spacing/2)
                        onAccept: Config.mapToken = text
                    }

                    LabledInput {
                        label.text: qsTr('user token')
                        input.placeholderText: qsTr('Enter user toke here')
                        width: page.vertical ? page.width : (page.width/2 - parent.spacing/2)
                        onAccept: Config.mapToken = text
                    }
                }
            }

            GSep{}
            Column {
                Head { text: qsTr('Appreance'); }
                Row {
                    ToolButton {
                        id: darkmode
                        width: 25; height: 25
                        enabled: !(Theme.rippleEffectItem && Theme.rippleEffectItem.running)
                        checkable: true
                        checked: true
                        text: checked ? '\ue094' : '\ue095'
                        font: Qomponent.font(Fonts.icon, {pointSize: 13})
                        onCheckedChanged: {
                            const center = Qt.point(width/2, height/2);
                            Theme.rippleEffectItem.center = mapToItem(Window.contentItem, center);
                            Theme.change(checked ? Theme.light : Theme.dark);
                        }
                    }
                    Label {
                        height: parent.height
                        text: darkmode.checked ? "Dark mode" : "Light mode"
                    }
                }

                Head { text: qsTr('Animations'); font.pointSize: 10 }
                CheckBox {
                    indicator { width: 24.675; height: 21 }
                    text: qsTr('Background animation')
                    checked: Config.backAnimation
                    onCheckedChanged: Config.backAnimation = checked
                }

                Head { text: qsTr('Main Page'); font.pointSize: 10 }
                CheckBox {
                    indicator { width: 24.675; height: 21 }
                    text: qsTr('Expanded indicators')
                    checked: Config.indicators
                    onCheckedChanged: Config.indicators = checked
                }
            }

            GSep{}
        }
    }
}
