import QtQuick 2.15
import QtQuick.Controls 2.15

import veqtor 0.1

Control {
    id: control

    leftInset: ylabels.width
    bottomInset: xlabels.height

    font.pixelSize: 8

    property Range xview: Range { min: 0; max: 100 }
    property Range yview: Range { min: 0; max: 100 }
    property vector2d tickcount: Qt.vector2d(4, 5)
    property real strokeWidth: 1
    property int maxBuffer: 5000
    property var values: []

    /**
     *
     *
     *
     */
    function push(value) {
        const val = value;
        if(typeof(val) == 'number') {
            control.values.push(val);
            if(values.length > maxBuffer) {
                values = values.slice(-control.maxBuffer);
            }
            internals.update();
            internals.size = values.length;
        }
    }

    QtObject {
        id: internals

        property real size: values.length
        property Range lastx: Range {}
        property Range xabs: Range {
            min: xview.min < 0 ? internals.size + xview.min : xview.min
            max: xview.max < 0 ? internals.size + xview.max : xview.max
        }
        property var dataView: values.slice(xview.min, xview.max)
        property var path: veq.document.p
        property real gapSize: veq.width / (xabs.dist - 1)

        onPathChanged: { update(); repaint(dataView); }
        onGapSizeChanged: { update(); repaint(dataView); }

        function update() {
            if(!path) return;
            dataView = values.slice(xview.min, xview.max);
            const pdsize = dataView.length, pathsize = path.size();
            if(pathsize < pdsize) {
                dataView.slice(-(pdsize - pathsize)).forEach((v, i) => {
                    const j = (pathsize + i);
                    const value = veq.height * (1 - (dataView[j] - yview.min) / yview.dist);
                    path.lineTo(Qt.point(j * gapSize, value));
                });
            } else {
                let s = pathsize;
                while(s-- > pdsize) path.shift();
                repaint(dataView);
            }
        }

        function repaint(data) {
            if(!path || (lastx.min === xabs.min && lastx.max === xabs.max)) return;
            const pathsize = path.size();
            const plist = data.slice(0, pathsize).map((v, i) => {
                const _v = veq.height * (1 - (v - yview.min) / yview.dist);
                return Qt.point(i * gapSize, _v);
            });
            path.set(plist);
        }
    }

    contentItem: Row {
        Column {
            id: ylabels
            spacing: veq.height/(tickcount.y - 1) - control.font.pixelSize

            Repeater {
                model: tickcount.y
                Text {
                    height: font.pixelSize - 1
                    font: control.font
                    color: palette.text
                    text: yview.max - Math.round(yview.dist * index / (tickcount.y - 1))
                }
            }
        }

        Column {
            id: column

            Veqtor {
                id: veq
                src: `<svg viewBox='0 0 300 100'><path id='p'/></svg>`

                onHeightChanged: {
                    internals.update();
                    internals.repaint(internals.dataView);
                }
                onSvgLoaded: {
                    const path = document.p;
                    root.viewBox.width = Qt.binding(() => control.availableWidth - ylabels.width);
                    root.viewBox.height = Qt.binding(() => control.availableHeight - xlabels.height);
                    path.strokeWidth = Qt.binding(() => control.strokeWidth);
                    path.stroke = Qt.binding(() => control.palette.highlight);
                }
            }

            Row {
                id: xlabels
                height: control.font.pixelSize * String(internals.xabs.max).length
                spacing: veq.width/(tickcount.x - 1) - control.font.pixelSize
                Repeater {
                    model: tickcount.x
                    Text {
                        width: font.pixelSize
                        color: palette.text
                        font: control.font
                        text: internals.xabs.min + Math.round(internals.xabs.dist * index / (tickcount.x-1))
                        transform: Rotation {
                            origin{x:0; y:0}
                            angle: 80
                        }
                    }
                }
            }
        }
    }

    background: Rectangle {
        color: palette.base
        border{width: 1; color: palette.alternateBase}
        radius: 1
        opacity: 0.5
    }
}
