import QtQuick 2.15
import QtQuick.Templates 2.15 as T

T.ToolButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    spacing: 0
    padding: 0

    contentItem: Text {
        id: text
        height: 10
        visible: control.display === T.AbstractButton.TextOnly ||
                 control.display === T.AbstractButton.TextBesideIcon;
        text:  control.text
        color: control.palette.buttonText
        opacity: control.down ? 0.8 : 1
        font: control.font
        elide: Text.ElideRight
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
    }
}
