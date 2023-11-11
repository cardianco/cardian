import QtQuick 2.15
import QtQuick.Controls 2.15

import QtPositioning 5.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

BasePage {
    id: page

    implicitHeight: 400

    contentItem: Control {
        padding: 5
        bottomPadding: 25
        topPadding: page.height - implicitContentHeight - bottomPadding - padding

        background: MapSystem {
            id: mapsystem
            anchors.fill: parent
            tapInserter.enabled: actions.path.checked
        }

        contentItem: Column {
            spacing: 5
            width: parent.width

            QGrid {
                x: parent.width - width
                vertical: true
                spacing: 2

                MapToolButton {
                    width: 35
                    plus.text: "\u002b"
                    minus.text: "\ue004"

                    plus.onPressed: mapsystem.zoomLevel += 0.1
                    minus.onPressed: mapsystem.zoomLevel -= 0.1
                }

                HexagonButton {
                    property PositionSource gps: PositionSource {
                        name: "geoclue2"
                        onPositionChanged: mapsystem.currentUserLocation = gps.position.coordinate;
                    }

                    width: 40
                    font: Fonts.icon
                    text: gps.active && gps.valid ? '\ue07a' : '\ue07b'

                    onClicked: {
                        gps.start();
                        gps.update();

                        mapsystem.center = gps.position.coordinate;
                    }
                }
            }

            QGrid {
                x: parent.width - width - 10
                vertical: true

                ToolButton {
                    text: "\ue07f"
                    font: Fonts.btnicon
                    palette.buttonText: page.palette.text
                    rotation: -mapsystem.bearing
                    onPressed: anim.start()

                    HoverHandler { cursorShape: Qt.PointingHandCursor }
                    property NumberAnimation anim: NumberAnimation {
                        target: mapsystem; property: 'bearing'
                        to: mapsystem.bearing < 180 ? 0 : 360
                        easing.type: Easing.InOutQuad
                        onFinished: mapsystem.bearing = 0
                        duration: 500
                    }
                }

                Label {
                    text: mapsystem.zoomLevel.toFixed(2)
                    font: Fonts.subscript
                }
            }

            Column {
                Label {
                    text: {
                        const props = ['latitude','longitude'];
                        return props.map(v => v + ': ' + mapsystem.center[v].toFixed(4)).join('\n');
                    }
                    font: Fonts.subscript
                }
                Label { text: "© MapboxGL - © OSM"; font: Fonts.subscript }
            }

            Column {
                spacing: 3
                width: parent.width

                MapActions {
                    id: actions

                    property int eindex: -1

                    width: parent.width

                    /// TODO seprate polygons
                    syncing: Object.keys(Status.reqHndlr.running).length

                    sync.onClicked: Status.fetchPolygons();

                    cancel.visible: mapsystem.activePolygon.count
                    cancel.onClicked: {
                        mapsystem.activePolygon.clear();
                        bounduryList.buttons.checkState = 0;
                        eindex = -1;
                    }

                    ok.visible: mapsystem.activePolygon.count > 2
                    ok.onClicked: {
                        const model = mapsystem.activePolygon;
                        const poly = Array(model.count).fill().map((_, i) => model.get(i));

                        if(eindex === -1) Status.polygons.append({poly: poly});
                        else Status.polygons.set(eindex, {poly: poly});

                        mapsystem.activePolygon.clear();
                        eindex = -1;
                    }

                    list.onCheckedChanged: if(!list.checked) Config.selectedMap = -1;
                }

                MapBounduryList {
                    id: bounduryList

                    model: Status.polygons
                    width: parent.width
                    height: actions.list.checked ? Math.min(80, implicitHeight) : 0

                    visible: list.count

                    onEditClicked: index => {
                        actions.eindex = index;
                        mapsystem.activePolygon.clear();

                        const polyn = model.get(index).poly;
                        const list = Array(polyn.count).fill().map((_, i) => polyn.get(i));

                        list.forEach(c => {
                            mapsystem.activePolygon.append({
                                latitude: c.latitude,
                                longitude: c.longitude
                            });
                        });
                    }

                    Behavior on height {NumberAnimation{}}
                }
            }
        }
    }
}
