import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Hive 1.0
import Qomponent 0.1

import cardian 0.1

BasePage {
    id: form

    property real bwidth: 65
    component Gap: Item { width: 65/2; height: 1 }

    contentData: Item {
        width: form.width
        height: form.height

        Grid {
            x: (parent.width - width)/2
            y: parent.height - height
            horizontalItemAlignment: Grid.AlignHCenter

            TriStateButton {
                width: 85 * 1.17
                font: Fonts.icon
                text: '\ue090'
                state: TriStateButton.Indeterminate
            }

            Gap { height: 45 }

            Grid {
                id: actions

                layoutDirection: Qt.RightToLeft
                horizontalItemAlignment: Grid.AlignHCenter
                spacing: -form.bwidth/2 + 5

                Row {
//                    layoutDirection: Qt.RightToLeft
                    TriStateButton {
                        font: Fonts.icon
                        text: '\ue033'
                    } Gap {}
                    TriStateButton {
                        font: Fonts.icon
                        text: '\ue063'
                    } Gap {}
                    TriStateButton {
                        font: Fonts.icon
                        text: '\ue07d'
                    }
                }

                Row {
                    HexagonButton {
                        font: Fonts.icon
                        text: '\ue173'
                    } Gap {}
                    HexagonButton {
                        font: Fonts.icon
                        text: '\ue037'
                    }
                }
            }
        }
    }
}