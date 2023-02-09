import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import Hive 1.0
import Qomponent 0.1

import cardian 0.1

BasePage {
    id: page

    property real itemswidth: 65
    oriention: width > height ? Qt.Horizontal : Qt.Vertical

    component Gap: Item { width: 65/2; height: 1 }
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

    header: Grid {
        opacity: 0.7
        flow: Grid.TopToBottom
        horizontalItemAlignment: Grid.AlignHCenter

        Item { height: 1; width: parent.width }
        Label {
            id: title
            text: stackView.currentItem.title
            font: Fonts.regular
            color: palette.windowText
        }

        Rectangle {
            width: 150; height: 1
            color: palette.button
        }
        height: 0
    }

    DataIndicator {
        width: page.width
        expanded: extraPage.StackView.status !== StackView.Active
    }

    contentData: StackView {
        id: stackView
        width: page.availableWidth
        height: page.availableHeight - navbar.height + 1
        initialItem: extraPage
    }

    footer: Grid {
        id: navbar
        bottomPadding: 5
        horizontalItemAlignment: Grid.AlignHCenter
        spacing: -page.itemswidth/2 + 5

        Item { height: 1; width: parent.width }
        Row {
            HexagonButton {
                font: Fonts.icon
                text: '\ue01c'

                onClicked: {
                    if(extraPage.StackView.status !== StackView.Active) {
                        stackView.replace(extraPage);
                    }
                }
            } Gap {}
            HexagonButton {
                font: Fonts.icon
                text: '\ue161'

                onClicked: {
                    if(homePage.StackView.status !== StackView.Active) {
                        stackView.replace(homePage);
                    }
                }
            } Gap {}
            HexagonButton {
                font: Fonts.icon
                text: '\ue07c'

                onClicked: {
                    if(navigationPage.StackView.status !== StackView.Active) {
                        stackView.replace(navigationPage);
                    }
                }
            }
        }

        Row { SemiHexagon {} Gap {} SemiHexagon {} }
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
    }

    Extra {
        id: extraPage
        visible: false
        oriention: page.oriention
    }
}
