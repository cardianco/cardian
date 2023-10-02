import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC

import Hive 1.0 as H

import cardian 0.1
import veqtor.qml 0.1
import Qomponent 0.1

QQC.Control {
    id: control

    property alias chart: chart
    property alias slider: slider
    property alias label: label

    readonly property real last: chart.list.last() ?? 0;

    contentItem: Column {
        padding: 5
        spacing: 10

        Label {
            id: label
            text: {
                const rate = chart.list.slice(-2).reduce((c,v) => c - v);
                const sign = 0 < rate ? '+' : '';
                return `Value: ${control.last.toFixed(1)}%\nRate: ${sign}${rate.toFixed(1)}%`;
            }
        }

        LineSeries {
            id: chart

            property real xsize: 50
            property int xoffset: (grid.offset.x/width + 0.5) * xsize

            font: Fonts.subscript
            width: control.availableWidth
            height: 100

            xaxis{min: slider.first.value; max: slider.second.value}
            yaxis{min: 0; max: 100}

            palette.highlight: control.palette.text

            background: GridRuler {
                id: grid

                filter: function(value, hr) {
                    if(!hr) return -value;
                    return value.qmap([0, width],[0, chart.xaxis.dist]).toFixed();
                }

                interactive: false
                origin: color
                opacity: 0.5

                step.y: 25
                step.x: 10000/chart.xaxis.dist

                offset {
                    x: width/2 + chart.xaxis.min.qmap([0, chart.xaxis.dist],[0, width])
                    y: -height/2 + 1
                }
            }
        }

        H.RangeSlider {
            id: slider

            padding: 0
            width: control.availableWidth - 10

            first.value: to - 200
            second.value: to - 100
            to: chart.list.count() + 100

            stepSize: 1
            snapMode: H.RangeSlider.SnapAlways
        }
    }
}
