import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1

import cardian 0.1

BasePage {
    id: page
    title: swipeview.currentItem.title

    contentItem: Column {
        padding: 5
        topPadding: 35

        TabBar {
            id: tabbar
            x: (parent.width - width)/2
            currentIndex: swipeview.currentIndex

            Repeater {
                model: ["Advanced", "Configuration", "Events"]
                TabButton {
                    text: modelData
                    width: implicitWidth
                    font: Fonts.regular
                }
            }
        }

        SwipeView {
            id: swipeview

            width: page.width - 2 * parent.padding
            height: page.height - y - 10

            topPadding: 10
            clip: true

            spacing: parent.padding * 2
            currentIndex: tabbar.currentIndex

            Advanced {
                oriention: page.oriention
                title: "Advanced Controls"
            }

            Configuration {
                oriention: page.oriention
                title: "Configuration"
            }

            Events {
                oriention: page.oriention
                title: "Commands Events"
            }
        }
    }
}
