import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15

import Hive 1.0
import cardian 0.1
import cardian.core 0.1

BasePage {
    id: page

    contentItem: Column {
        Row {
            id: header
        }

        ListView {
            id: listview
            width: page.width; height: page.height - header.height
            spacing: 3
            model: Status.events

            delegate: EventItem {
                width: page.width
                index: model.index
                recordId: model.id
                timestamp: model.utc
                text: model.title
                desc.text: JSON.stringify(JSON.parse(model.text), null, 2)
                priority: 0
            }
        }
    }
}
