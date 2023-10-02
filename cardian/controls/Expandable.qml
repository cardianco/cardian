import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1
import cardian 0.1

Page {
    id: control

    property alias icon: icon
    property alias label: label
    property alias desc: description
    property alias expanded: btn.checked

    property bool exclusiveExpand: true
    property real expandHeight: implicitContentHeight +
                                implicitHeaderHeight +
                                implicitFooterHeight

    height: expanded ? expandHeight : header.height + footer.height

    clip: true
    font: Qomponent.font(Fonts.icon, {pixelSize: 15})

    onExpandedChanged: {
        if(exclusiveExpand && expanded && parent) {
            Object.values(parent.children).forEach(el => {
                if(el !== this && el.hasOwnProperty('expanded')) {
                    el.expanded = false;
                }
            });
        }

        if(expanded && parent && parent.hasOwnProperty('currentItem')) {
            parent.currentItem = this;
        }
    }

    Behavior on height {SmoothedAnimation {duration: 700}}

    header: Row {
        padding: 5; spacing: 5
        Label {
            id: icon
            font: control.font
            opacity: 0.5
        }

        Label {
            id: label
            opacity: 0.5
            text: control.title
            font: Fonts.regular
        }

        Label {
            id: description
            color: control.palette.button
            visible: control.height < 60
            opacity: 20 / (control.height - 20)
        }
    }

    footer: ToolButton {
        id: btn
        implicitHeight: 15
        checkable: true
        text: checked ? '\ue133' : '\ue134'
        font: control.font
        opacity: 0.6
        background: Rectangle {
            color: Qomponent.alpha(palette.button, btn.checked ? 0 : 0.2)
            Rectangle {
                y: parent.height - 1
                width: parent.width; height: 1
                color: palette.button
            }
        }
    }
}
