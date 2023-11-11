pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import QtPositioning 5.15

import Qomponent 0.1 /// Object.qget()

import cardian 0.1 /// JsUtils
import cardian.core 0.1

Control {
    id: control

    property vector2d frontLights: Qt.vector2d(0, 0)
    property vector3d rearLights: Qt.vector3d(0, 0, 0)
    property vector4d doors: Qt.vector4d(0, 0, 0, 0)

    property bool lock: false // Status.UnLock
    property bool network: false // Status.On
    property bool gps: false // Status.Off
    property bool alarm: false // Status.Enable
    property bool bluetooth: false // Status.Off
    property bool engine: false // Status.Off

    property int updown: 0 // Upload/Download
    property real fuel: 0 // Fuel value
    property real temperature: 0
    property real battery: 0

    property real lastUpdate: 0

    property point location: Qt.point(0,0)

    property EventModel events: EventModel {}
    property ListModel polygons: ListModel {
        property bool blockInsert: false
        onRowsInserted: (_, index) => {if(!blockInsert) addPolygon(index)};
        onRowsAboutToBeRemoved: (_, index) => removePolygon(polygons.get(index).id);
        onDataChanged: ({row}) => updatePolygon(index);
    }

    property RequestHandler reqHndlr: RequestHandler {
        property var responses: Object();

        function graphAPI(body) {
            return postRequest(Config.api, JSON.stringify(body), {stoken: Config.token})
        }

        onErrorOccurred: emsg => print('error:', emsg);
        onFinished: function(data, id) {
            if(typeof responses[id].callback == 'function') {
                const args = responses[id].args ?? [];
                responses[id].callback(data, ...args);
                delete responses[id];
            }
        }
    }

    function fetchLatestStatuses() {
        const body = { query: 'query{latestStatus{data}}' };
        const id = reqHndlr.graphAPI(body);

        reqHndlr.responses[id] = {
            callback: result => {
                const data = JsUtils.parseJson(result, {}).qget('data.latestStatus.data');
                const statuses = JsUtils.flattenObject(JsUtils.parseJson(data, {}));

                if(statuses) {
                    const parsed = JsUtils.parseStatusData(statuses);
                    Object.keys(parsed).forEach(key => {
                        if(control.hasOwnProperty(key)) {
                            control[key] = parsed[key];
                        }
                    });
                }
            }
        };
    }

    function fetchStatuses() {
        const limit = 100, start = events.first() ?? {};
        const body = { query: `query{statusHistory(limit:${limit},start:${start.id ?? -1}){id fieldType{id name} data utc}}` };
        const id = reqHndlr.graphAPI(body);

        reqHndlr.responses[id] = {
            callback: result => {
                const history = JsUtils.parseJson(result, {}).qget('data.statusHistory', []);
                if(history) {
                    history.forEach(record => {
                        const {id, fieldType, data, utc} = record;
                        events.append(id, fieldType.name, data, utc, fieldType.id);
                    });
                }
            }
        };
    }

    function updatePolygon(index) {
        const {poly, id} = polygons.get(index);
        if(!id) return false;

        const list = JsUtils.toGQLPoints(JsUtils.polygonToList(poly));
        const body = { query: `mutation{updateBoundary(id: ${id}, stateId:1, poly:[${list}])}` };
        const reqId = reqHndlr.graphAPI(body);

        reqHndlr.responses[reqId] = {
            callback: result => {
                const json = JsUtils.parseJson(result).data;
                if(json === undefined) return;
                const res = json.updateBoundary ?? NaN;

                print(`Updated polygon: ${res}`);
            }
        };
    }

    function addPolygon(index) {
        const model = polygons.get(index).poly;
        const list = JsUtils.toGQLPoints(JsUtils.polygonToList(model));

        const body = { query: `mutation{createBoundary(stateId:1 poly:[${list}])}` };
        const id = reqHndlr.graphAPI(body);

        reqHndlr.responses[id] = {
            args: [index],
            callback: (result, index) => {
                if(!result) return;
                const json = JsUtils.parseJson(result);
                const id = json.qget('data.createBoundary', NaN);
                polygons.setProperty(index, 'id', id);

                print(`Added new polygon (id:${id})`);
            }
        };
    }

    function removePolygon(index) {
        if(index === undefined) return;
        const body = { query: `mutation{removeBoundaries(idList: [${index}])}` };
        const id = reqHndlr.graphAPI(body);

        reqHndlr.responses[id] = {
            args: [index],
            callback: (result, index) => {
                const json = JsUtils.parseJson(result);
                const num = json.qget('data.boundaries', null);

                if(1 <= num) {
                    print(`Removed polygons (num:${num})`);
                }
            }
        }
    }

    function fetchPolygons(id = undefined) {
        const list = Array(polygons.count).fill().map((_,i) => polygons.get(i).id ?? 0);
        const maxId = id ?? Math.max(...list, -1);
        const body = { query: `query{boundaries(start:${maxId}){id utc state{name} poly{y x}}}` };
        const reqId = reqHndlr.graphAPI(body);

        reqHndlr.responses[reqId] = {
            callback: result => {
                const json = JsUtils.parseJson(result);
                if(!json) return;

                const boundaries = json.qget('data.boundaries', []);

                polygons.blockInsert = true;
                boundaries.forEach(function({id, utc, state, poly}) {
                    const mapPoly = poly.map(p => QtPositioning.coordinate(p.y, p.x));
                    polygons.append({ id, poly: mapPoly, utc, state: state.name ?? '' });
                });
                polygons.blockInsert = false;

                print(`Fetched polygons (num:${boundaries.length})`);
            }
        }
    }

    /// Automated fetch data
    property Timer timer: Timer {
        interval: 60000
        repeat: true; running: true
        triggeredOnStart: true
        onTriggered: {
            fetchPolygons();
            fetchStatuses();
            fetchLatestStatuses();

            control.lastUpdate = Date.now();
        }
    }

    Binding {
        target: Config
        property: 'processing'
        value: Object.keys(reqHndlr.running).length
    }

    Settings {
        fileName: "config.ini"
        category: "Configuration/Status"

        property alias lastUpdate: control.lastUpdate
        property alias location: control.location
    }
}
