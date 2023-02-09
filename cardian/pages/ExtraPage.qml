import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1

import cardian 0.1

BasePage {
    id: page
    title: swipeview.currentItem.title

    contentData: Grid {
        width: page.width
        height: page.height
        padding: 5
        topPadding: 35
        horizontalItemAlignment: Grid.AlignHCenter

        TabBar {
            id: tabbar
            currentIndex: swipeview.currentIndex

            TabButton {
                text: "Advanced"
                width: implicitWidth
            }

            TabButton {
                text: "Configuration"
                width: implicitWidth
            }

            TabButton {
                text: "History"
                width: implicitWidth
            }
        }

        SwipeView {
            id: swipeview
            width: parent.width - 2 * parent.padding
            height: page.height - y - 10
            currentIndex: tabbar.currentIndex
            topPadding: 10
            spacing: parent.padding * 2
            clip: true

            Advanced {
                oriention: page.oriention
                title: "Advanced Controls"
            }

            Configuration {
                oriention: page.oriention
                title: "Configuration"
            }

            History {
                oriention: page.oriention
                title: "Commands History"
            }
        }
    }
}
