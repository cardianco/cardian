import QtQuick 2.15
import QtQuick.Controls 2.15

import cardian 0.1

Expandable {
    id: control

    title: 'fuel'
    icon.text: '\ue141'
    desc.text: `Value: ${chart.last.toFixed(1)}%`
    expandHeight: chart.height + 100

    contentData: Column {
        padding: 5
        topPadding: 15
        spacing: 10
        visible: control.height > 50

        Label {
            text: {
                const values = chart.values;
                const rate = values.slice(-2).reduce((c,v) => c - v);
                const sign = rate < 0 ? '' : '+';
                return `Value: ${chart.last.toFixed(1)}%\nRate: ${sign}${rate.toFixed(1)}%`;
            }
        }

        LineSeries {
            id: chart

            property real last: values.slice(-1)[0] ?? NaN;

            font: Fonts.subscript
            width: control.availableWidth - 10; height: 100

            palette {
                base: 'transparent'
                highlight: '#0777a1'
                alternateBase: '#880777a1'
            }

            values: Array(100).fill().map((_,i) => Math.random() * 10 + 30)
            xview{min: -100; max: -1}
            tickcount{x: 0; y: 5}
        }
    }
}
