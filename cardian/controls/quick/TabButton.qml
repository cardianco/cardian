import QtQuick 2.15
import QtQuick.Templates 2.15 as T

T.TabButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 6
    spacing: 6

    contentItem: Label {
        text: control.text
        font: control.font
        color: control.palette.windowText
        opacity: control.checked ? 1.0 : 0.7
    }

    HoverHandler { cursorShape: Qt.PointingHandCursor }
}
