import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

BasePage {
    id: page

    component GridSep: GridSeparator {
        padding: 10
        contentItem{color: page.palette.button; opacity: 1}
    }

    contentData: Flickable {
        width: page.width
        height: page.height - 25

        contentWidth: grid.width
        contentHeight: grid.height

        flickableDirection: Flickable.VerticalFlick

        ScrollBar.vertical: ScrollBar {
            x: parent.width - width; width: active ? 8 : 5
            Behavior on width {NumberAnimation {}}
        }

        /**
         * The following lines simulate auto-scrolling to the expanded item.
         * TODO: Write a better solution.
         */
        onContentHeightChanged: {
            const item = grid.currentItem;
            if(item) {
                const vscroll = this.ScrollBar.vertical;
                const itop = item.y, ibottom = item.y + item.height,
                      vbottom = contentY + height;

                if(ibottom > vbottom) {
                    Qt.callLater(vscroll.increase);
                } else if(itop < contentY) {
                    Qt.callLater(vscroll.decrease);
                }
            }
        }

        QGrid {
            id: grid

            property var currentItem: undefined
            vertical: true
            spacing: 8

            Expandable {
                width: page.availableWidth;
                expandHeight: 200
                topPadding: footer.height
                title: qsTr('live location')
                icon.text: '\ue07a'
                desc.text: '? N, ? E'

                contentData: Label {
                    text: 'Longitude: ?\n' + 'Latitude: ?'
                }
            }

            LightsStatus  { width: page.availableWidth; }
            DoorsStatus   { width: page.availableWidth; }
            FuelStatus    { width: page.availableWidth; }
            BatteryStatus { width: page.availableWidth; }
            SeatsStatus   { width: page.availableWidth; }
        }
    }
}
