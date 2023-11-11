import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1
import cardian.core 0.1
import SortFilterProxyModel 0.2

BasePage {
    id: page

    SortFilterProxyModel {
        id: proxyModel

        sourceModel: Status.events
        sorters: StringSorter { roleName: "id" }
        filters: RegExpFilter {
            roleName: searchField.currentItem.modelData ?? 'title'
            pattern: searchBar.text
            caseSensitivity: Qt.CaseInsensitive
        }
    }

    contentItem: Column {
        spacing: 5
        Row {
            id: header
            width: parent.width; height: 25

            Label {
                text: 'Events'
                font: Fonts.head
            }
        }

        VRow {
            width: parent.width

            Label {
                text: 'Search:'

                ListView {
                    id: searchField
                    x: 25; y: 15; height: 20; width: 20

                    preferredHighlightBegin: 0.5
                    preferredHighlightEnd: 0.5
                    highlightRangeMode: ListView.StrictlyEnforceRange

                    spacing: 10
                    orientation: Qt.Horizontal
                    snapMode: ListView.SnapToItem
                    model: ['title', 'text', 'id', 'utc', 'type']
                    delegate: Label {
                        required property string modelData
                        text: '(' + modelData + ')'; font: Fonts.subscript
                    }
                }
            }

            TextField {
                id: searchBar
                width: page.availableWidth - 60
                height: contentHeight + 2 * padding
                selectByMouse: true
                selectionColor: palette.button
                Component.onCompleted: {
                    background.corners = Qt.vector4d(3,3,3,3)
                }
            }
        }

        ListView {
            id: listview
            width: page.width; height: page.availableHeight -
                                       (header.height + searchBar.height + 10)
            spacing: 3
            model: proxyModel
            clip: true

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
