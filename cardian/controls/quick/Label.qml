import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC

import Qomponent 0.1

QQC.Label {
    id: control
    color: palette.windowText
    font: Qomponent.font(Fonts.regular, {bold: true, weight: Font.Bold})
    verticalAlignment: Qt.AlignVCenter
}
