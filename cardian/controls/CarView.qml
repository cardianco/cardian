import QtQuick 2.15
import QtQuick.Controls 2.15

import veqtor 0.1

Control {
    id: control

    component Anim: NumberAnimation{easing.type: Easing.OutBack}

    property alias source: veq.src
    property real strokeWidth: 2
    property vector2d frontLights
    property vector3d rearLights
    property vector4d doors

    QtObject {
        id: colors
        readonly property color button: control.palette.button
        readonly property color text: control.palette.text
    }

    Behavior on doors.x {Anim{}}
    Behavior on doors.y {Anim{}}
    Behavior on doors.z {Anim{}}
    Behavior on doors.w {Anim{}}

    readonly property var doorsConfig: [
        {id:'flDoor', org: Qt.point(90 ,340), angle: doors.x},
        {id:'frDoor', org: Qt.point(355,340), angle:-doors.y},
        {id:'blDoor', org: Qt.point(90 ,500), angle: doors.z},
        {id:'brDoor', org: Qt.point(355,500), angle:-doors.w},
    ];

    contentItem: Veqtor {
        id: veq
        visible: false

        onSvgLoaded: {
            const list = control.doorsConfig;
            // Set origins.
            list.forEach(v => veq.document[v.id].origin = v.org);
            // Bind elements to data array.
            list.forEach((v, i) => {
                veq.document[v.id].transform = Qt.binding(() => [{
                    t:'rotate', angle: control.doorsConfig[i].angle
                }]);
            });

            document.rcLight.fill.a = Qt.binding(() => rearLights.x);
            document.rrLight.fill.a = Qt.binding(() => rearLights.y);
            document.rlLight.fill.a = Qt.binding(() => rearLights.z);

            document.frLight.stroke = Qt.binding(()   => frontLights.y ? colors.text : colors.button);
            document.frLightx.opacity = Qt.binding(() => frontLights.y === 1);
            document.frLighty.opacity = Qt.binding(() => frontLights.y === 2);

            document.flLight.stroke = Qt.binding(()   => frontLights.x ? colors.text : colors.button);
            document.flLightx.opacity = Qt.binding(() => frontLights.x === 1);
            document.flLighty.opacity = Qt.binding(() => frontLights.x === 2);

            Object.values(document).forEach(el => {
                if(el) el.strokeWidth = Qt.binding(() => control.strokeWidth);
            });

            ['body','p1','p2','p3','trunk','hood','ceil',
             'flDoor','frDoor','blDoor','brDoor'].forEach(id => {
                document[id].stroke = Qt.binding(() => palette.button);
            });

            visible = true;
        }
    }
}
