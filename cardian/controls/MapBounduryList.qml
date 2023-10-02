import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1

import cardian 0.1

Control {
    id: control

    implicitWidth: 200
    implicitHeight: contentItem.contentHeight + 2 * padding

    padding: 2

    property alias list: listview
    property alias model: listview.model
    property ButtonGroup buttons: ButtonGroup {}

    signal editClicked(int id)
    signal remove(int id)
    signal select(int id)

    component DataButton: AbstractButton {
        id: button

        property string subscript
        property Label label: Label { font: Fonts.regular }
        property ToolButton edit: ToolButton { font: Fonts.icon }
        property ToolButton clone: ToolButton { font: Fonts.icon }
        property ToolButton remove: ToolButton {
            font: Fonts.icon
            palette.buttonText: Qt.tint(control.palette.window, '#99ff0000')
        }

        padding: 2
        rightPadding: 5
        checkable: true

        Rectangle {
            width: 1 + 2 * button.checked
            height: parent.height
            color: palette.button

            Behavior on width {NumberAnimation{duration: 50}}
        }

        contentItem: VRow {
            HoverHandler { cursorShape: Qt.PointingHandCursor }
            property list<Item> items: [
                Label {
                    leftPadding: 5
                    text: button.text
                    opacity: 0.7 + 0.3 * !button.down
                    font: Fonts.regular
                },
                Label {
                    padding: 2
                    text: button.subscript
                    font: Fonts.subscript; opacity: 0.7
                },
                Row {
                    spacing: 3
                    children: [clone, edit, remove]
                }
            ];

            children: [items[0], items[1], label, items[2]]
        }

        background: Rectangle {
            opacity: 0.3
            width: button.availableWidth; height: 1
            color: palette.button
        }
    }

    contentItem: ListView {
        id: listview
        clip: true

        ScrollBar.vertical: ScrollBar {
            palette.mid: control.palette.buttonText
            width: 7; active: true
        }

        delegate: DataButton {
            property var serverId: (model.get(index) ?? {}) .id
            required property int index
            required property var poly

            width: ListView.view.width

            text: index + 1
            subscript: 'id: ' + (serverId ?? 'not synced')
            label.text: `[...${poly.count}...]`
            edit.text: '\ue06a'
            clone.text: '\ue188'
            remove.text: '\ue18d'

            onCheckedChanged: Config.selectedMap = index;
            edit.onClicked: control.editClicked(index)

            remove.onClicked: {
                control.model.remove(index);
                control.remove(index);
            }

            clone.onClicked: {
                const data =  Array(poly.count).fill().map((_, i) => poly.get(i));
                model.append({poly: data});
            }

            background.visible: index
            ButtonGroup.group: control.buttons
        }
    }

    background: Rectangle {
        color: Qomponent.alpha(palette.button, 0.2)
        border.color: palette.button
        radius: 3
    }
}
