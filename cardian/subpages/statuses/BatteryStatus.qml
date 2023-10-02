import QtQuick 2.15
import cardian 0.1

Expandable {
    id: control

    title: qsTr('battery')
    icon.text: '\ue168'
    desc.text: `Value: ${contentItem.last.toFixed(1)}%`

    contentItem: RangeLineSeries {
        width: control.availableWidth
        visible: 50 < control.height

        Component.onCompleted: {
            chart.list.setData(Array(1000).fill().map((_,i) => Math.random() * 25 + 25))
        }
    }
}
