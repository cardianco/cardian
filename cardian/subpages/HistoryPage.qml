import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import cardian 0.1

BasePage {
    id: page

    contentData: ScrollView {
        width: page.width
        height: page.height

        contentWidth: grid.width
        contentData: Grid {
            id: grid
        }
    }
}
