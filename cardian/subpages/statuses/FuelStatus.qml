import QtQuick 2.15
import cardian 0.1

Expandable {
    id: control

    title: 'fuel'
    icon.text: '\ue141'
    desc.text: `Value: ${contentItem.last.toFixed(1)}%`

    contentItem: RangeLineSeries {
        visible: 50 < control.height
        width: control.availableWidth

        Component.onCompleted: {
            chart.list.setData(Array(1000).fill().map((_,i) => Math.random() * 25 + 25))
        }
    }
}
