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

    font: Fonts.regular

    contentItem: Flickable {
        contentWidth: grid.width
        contentHeight: grid.height
        flickableDirection: Flickable.VerticalFlick

        ScrollBar.vertical: ScrollBar {
            x: parent.width - width; width: active ? 8 : 5
            Behavior on width {NumberAnimation {}}
        }

        QGrid {
            id: grid
            width: page.width
            vertical: true
            horizontalItemAlignment: Grid.AlignLeft
            bottomPadding: 20
            spacing: 5

            Column {
                Head { text: qsTr('API Tokens'); topPadding: 10 }
                QGrid {
                    vertical: true
                    spacing: 5
                    preferredRows: !page.vertical + 1

                    LabledInput {
                        width: page.vertical ? page.width : (page.width - parent.spacing)/2

                        label.text: qsTr('map token')
                        input.text: Config.mapToken
                        input.placeholderText: qsTr('Enter MapGL token here')

                        onAccepted: text => Config.mapToken = text;
                    }

                    LabledInput {
                        width: page.vertical ? page.width : (page.width - parent.spacing)/2

                        label.text: qsTr('session token')
                        input.text: Config.token
                        input.placeholderText: qsTr('Enter session token here')

                        onAccepted: text => Config.token = text;
                    }

                    LabledInput {
                        width: page.vertical ? page.width : (page.width - parent.spacing)/2

                        label.text: qsTr('API url')
                        input.text: Config.api
                        input.placeholderText: qsTr('Enter api url here')

                        onAccepted: text => Config.api = text;
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
                        enabled: !Theme.rippleEffectItem.running
                        checkable: true
                        text: checked ? '\ue094' : '\ue095'
                        font: Qomponent.font(Fonts.icon, {pixelSize: 16})

                        onCheckedChanged: {
                            const center = Qt.point(width/2, height/2);
                            Theme.rippleEffectItem.center = mapToItem(Window.contentItem, center);
                            Theme.change(!checked ? 'dark' : 'light');
                        }
                    }

                    Label {
                        height: parent.height
                        text: darkmode.checked ? qsTr("Dark mode") : qsTr("Light mode")
                    }
                }

                Head { text: qsTr('Animations'); font.pixelSize: 13 }

                CheckBox {
                    padding: 2
                    indicator { width: 24.675; height: 21 }
                    text: qsTr('Background animation')
                    checked: Config.backAnimation
                    onCheckedChanged: Config.backAnimation = checked
                }

                Head { text: qsTr('Main Page'); font.pixelSize: 13 }

                CheckBox {
                    padding: 2
                    indicator { width: 24.675; height: 21 }
                    text: qsTr('Expanded indicators')
                    checked: Config.indicators
                    onCheckedChanged: Config.indicators = checked
                }
            }

            Column {
                spacing: 4

                Head {
                    text: qsTr('Font Selector')
                    font.pixelSize: 13
                }

                FontSelector {
                    width: page.availableWidth
                    height: 180
                    font: Qt.font({pixelSize: 12})
                    target: Fonts
                    properties: ['icon', 'btnicon', 'head', 'mono', 'regular', 'subscript']

                    palette.base: '#2aa2dd'
                    palette.alternateBase: '#2aa2dd'
                }
            }

            Column {
                spacing: 4

                Head {
                    text: qsTr('Theme Editor');
                    font.pixelSize: 13
                }

                VRow {
                    width: page.availableWidth
                    CheckBox {
                        id: themeLiveEdit
                        padding: 0
                        topPadding: 0
                        indicator{width: 20 * 1.175; height: 20}
                        text: qsTr('Live edit')
                    }

                    Button {
                        y: 3
                        text: qsTr('Save')
                        width: 50; height: 20
                        visible: themeeditor.bufferPalette !== themeeditor.target[themeeditor.property]
                        onClicked: themeeditor.save()
                    }
                }

                ThemeEditor {
                    id: themeeditor
                    target: Theme
                    property: Theme.active
                    width: page.availableWidth
                    height: 200
                    onBufferPaletteChanged: themeLiveEdit.checked && save()

                    palette.alternateBase: '#2aa2dd'
                    palette.base: '#2aa2dd'
                }
            }
        }
    }
}
