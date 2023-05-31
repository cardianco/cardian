import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15

import Hive 1.0
import cardian 0.1

BasePage {
    id: page

    ListModel {
        id: listmodel
        ListElement {
            type: 0; timestamp: 1685345020; desc: ''
            title: 'header hader'
        }
        ListElement {
            type: 1; timestamp: 1685344020; desc: 'type'
            title: ''
        }
    }

    contentData: Column {
        width: page.width
        height: page.height

        Row {
            id: header
        }

        ListView {
            id: listview
            width: page.width; height: page.height - header.height
            spacing: 3
            model: listmodel

            delegate: EventItem {
                width: page.width
                num: model.index
                timestamp: model.timestamp
                title.text: model.title
                desc.text: model.desc
                type: EventItem.Info
            }
        }
    }
}
