import QtQuick 2.15
import QtQuick.Controls 2.15

import cardian 0.1

Expandable {
    id: control

    title: 'battery'
    icon.text: '\ue168'
    desc.text: `Charge: ${chart.last.toFixed(1)}%`
    expandHeight: chart.height + 100

    contentData: Column {
        padding: 5
        topPadding: 15
        spacing: 10

        Label {
            text: {
                const values = chart.values;
                const rate = values.slice(-2).reduce((c,v) => c - v);
                const sign = rate < 0 ? '' : '+';
                return `Charge: ${chart.last.toFixed(1)}%\nRate: ${sign}${rate.toFixed(1)}%`;
            }
        }

        LineSeries {
            id: chart

            property real last: values.slice(-1)[0] ?? NaN;

            font: Fonts.subscript
            width: control.availableWidth - 10
            height: 100
            visible: control.height > 60

            palette {
                base: 'transparent'
                highlight: '#07a'
                alternateBase: '#880777a1'
            }

            values: Array(100).fill(0).map((_,i) => Math.random() * 10 + 60)
            xview{min: -100; max: -1}
            tickcount{x: 0; y: 5}
        }
    }
}
