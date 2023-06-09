import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1 as QQ
import cardian 0.1
import veqtor 0.1

Expandable {
    id: control

    title: qsTr('doors')
    icon.text: '\ue17e'

    // TODO: replace this with real door statuses
    desc.text: doorsStatus(internals.doorsInt)
    expandHeight: 200

    property real angle: 0
    property vector4d doors

    Behavior on angle {SpringAnimation{spring: 2; damping: 0.2}}
//    Behavior on doors.x {NumberAnimation{}}
//    Behavior on doors.y {NumberAnimation{}}
//    Behavior on doors.z {NumberAnimation{}}
//    Behavior on doors.w {NumberAnimation{}}

    /**
     * @abstract This function determines the status of car doors and returns a corresponding message.
     * @param doors {vector4d}, doors status
     *   x|y
     *   z|w
     */
    function doorsStatus(doors) {
        const count = doors.x + doors.y + doors.z + doors.w;
        let front = '', rear = '';

        if(doors.x ^ doors.y) front += 'front ' + (doors.x ? 'left' : 'right');
        else if(doors.x) front += 'Both front';
        if(doors.z ^ doors.w) rear += 'rear ' + (doors.z ? 'left' : 'right');
        else if(doors.z) rear += 'both rear';

        return !count ? 'All doors are closed' :
                count === 4 ? 'All doors are open' :
                count === 1 ? `Only ${front || rear} door is open` :
                front && rear ? `${front} and ${rear} doors are open` : `${front || rear} doors are open`;
    }

    QtObject {
        id: internals

        property vector4d doorsInt: {
            return Qt.vector4d(...Object.values(doors).map(v => Math.floor(v)))
        }
        readonly property var doorsConfig: [
            {id:'frontLeft' , org: Qt.point(90 ,340), angle: (doors.x *  35)},
            {id:'frontRight', org: Qt.point(355,340), angle: (doors.y * -35)},
            {id:'rearLeft'  , org: Qt.point(90 ,500), angle: (doors.z *  35)},
            {id:'rearRight' , org: Qt.point(355,500), angle: (doors.w * -35)},
        ];
    }

    contentData: Item {
        visible: control.height > 50

        Row {
            spacing: 5
            ToolButton {
                property bool doorSt: Object.values(doors).some(v => v);
                text: doorSt ? '\ue063' : '\ue061'
                onClicked: doors = doorSt ? Qt.vector4d(0,0,0,0) : Qt.vector4d(1,1,1,1)
            }

            Label {
                text: control.desc.text
                opacity: 0.8
            }
        }

        Grid {
            y: 60; x: (control.availableWidth - width)/2
            spacing: 5; columns: 2
            rotation: -angle

            Repeater {
                model: ['x','y','z','w']
                ToolButton {
                    property bool doorSt: doors[modelData]
                    rotation: angle
                    text: doorSt ? '\ue063' : '\ue061'
                    palette.buttonText: doorSt ? control.palette.base : '#aa50d160'
                    font: QQ.Qomponent.font(Fonts.icon, {pointSize: 16})
                    onPressed: doors[modelData] = !doorSt
                }
            }
        }

        Veqtor {
            x: (control.availableWidth - width)/2
            width: 170; height: width
            rotation: -angle

            src: 'qrc:/resources/images/doors.svg'

            onSvgLoaded: {
                const list = internals.doorsConfig;
                // Set origins.
                list.forEach(v => document[v.id].origin = v.org);
                // Bind elements to data array.
                list.forEach((v, i) => {
                    document[v.id].transform = Qt.binding(() => [{
                        t:'rotate', angle: internals.doorsConfig[i].angle
                    }]);
                });

                ['body','p1','p2','p3','hood','ceil'].forEach(id => {
                    document[id].stroke = Qt.binding(() => control.palette.text);
                });
            }
        }
    }
}
