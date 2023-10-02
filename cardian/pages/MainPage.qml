import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1

import cardian 0.1

BasePage {
    id: page

    property real itemswidth: 65
    oriention: width > height ? Qt.Horizontal : Qt.Vertical

    component SemiHexagon: Item {
        width: page.itemswidth; height: width/2 - 6
        clip: true
        Hexagon {
            width: parent.width; height: width * 0.85106
            opacity: 0.5
            strokeWidth: 1; radius: 5
            color: strokeColor
            strokeColor: palette.button
        }
    }

    header: QGrid {
        height: 0
        opacity: 0.7
        flow: Grid.TopToBottom

        Item { height: 1; width: parent.width }
        Label {
            id: title
            text: stackView.currentItem.title
            font: Qomponent.font(Fonts.regular, {weight: Font.ExtraBold})
            color: palette.windowText
        }

        Rectangle {
            width: 150; height: 1
            color: palette.button
        }
    }

    DataIndicator {
        width: page.width
        expanded: extraPage.StackView.status !== StackView.Active && Config.indicators
    }

    contentData: StackView {
        id: stackView
        width: page.availableWidth
        height: page.availableHeight - navbar.height + 1
        initialItem: homePage
    }

    footer: QGrid {
        id: navbar
        bottomPadding: 5
        vertical: true
        spacing: -page.itemswidth/2 + 5

        Item { height: 1; width: parent.width }
        Row {
            spacing: itemswidth/2
            HexagonButton { // Configuration
                font: Fonts.btnicon
                text: '\ue01c'

                onClicked: {
                    if(extraPage.StackView.status !== StackView.Active) {
                        stackView.replace(extraPage);
                    }
                }
            }

            HexagonButton { // Home
                font: Fonts.btnicon
                text: '\ue160'

                onClicked: {
                    if(homePage.StackView.status !== StackView.Active) {
                        stackView.replace(homePage);
                    }
                }
            }

            HexagonButton { // Navigation
                font: Fonts.btnicon
                text: '\ue079'

                onClicked: {
                    if(navigationPage.StackView.status !== StackView.Active) {
                        stackView.replace(navigationPage);
                    }
                }
            }
        }

        Row {
            spacing: itemswidth/2
            SemiHexagon {}
            SemiHexagon {}
        }
    }

    Navigation {
        id: navigationPage
        title: "Navigation"
        visible: false
        oriention: page.oriention
    }

    Home {
        id: homePage
        title: "Home"
        visible: false
        oriention: page.oriention
        background.opacity: 0.0
    }

    Extra {
        id: extraPage
        visible: false
        oriention: page.oriention
    }

    background: HexagonEffect {
        color: palette.window
        strokeColor: palette.window
        mask: true; strokeMask: true

        strokeSource: ShaderEffectSource {
            sourceItem: Plasma {
                color: palette.button
                secondary: palette.window
                running: Config.backAnimation
                width: page.width; height: page.height
            }
        }

        source: ShaderEffectSource {
            sourceItem: Plasma {
                color: palette.base
                secondary: palette.window
                running: Config.backAnimation
                width: page.width; height: page.height
            }
        }
    }
}
