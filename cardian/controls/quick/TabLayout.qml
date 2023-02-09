import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12



Row {
    id: control

    default property alias items: stacklayout.children
    property alias tabs: repeater.model
    property alias currentIndex: sideBar.currentIndex
    property real sidebarThreshold: 600

    spacing: 5
    padding: 5

    children: [
        Column {
            id: sideBar

            spacing: 5
            height: parent.height
            width: childrenRect.width
            clip: true

            property real currentIndex: 0

            Repeater {
                id: repeater
                TabButton {
                    text: modelData.text ?? modelData
                    iconx.font: Fonts.icon
                    iconx.text: modelData.icon ?? ""

                    font: Fonts.regular

                    display: control.width < control.sidebarThreshold ? TabButton.IconOnly : TabButton.TextBesideIcon
                    width: implicitWidth
                }
            }

            Behavior on width { SmoothedAnimation {} }
        },
        GridSeparator { length: stacklayout.height; fill: 1 },
        StackLayout {
            id: stacklayout
            clip: true
            width: parent.width - sideBar.width -
                   (control.spacing + control.padding) * 3
            height: parent.height - control.padding * 6
            currentIndex: sideBar.currentIndex
        }
    ]
}
