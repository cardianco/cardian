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
        onRowsInserted: (_, index) => {if(!priv.fetching) addPolygon(index)};
        onRowsAboutToBeRemoved: (_, index) => removePolygon(polygons.get(index).id);
        onDataChanged: ({row}) => updatePolygon(index);
    }

    function fetchLatestStatuses() {
        const body = { query: 'query{latestStatus{data}}' };
        return latestDataRequest.postRequest(Config.api, JSON.stringify(body), {stoken: Config.token});
    }

    function fetchStatuses() {
        const limit = 100, start = events.first() ?? {};
        const body = { query: `query{statusHistory(limit:${limit},start:${start.id ?? -1}){id fieldType{id name} data utc}}` };
        return historyRequest.postRequest(Config.api, JSON.stringify(body), {stoken: Config.token});
    }

    function updatePolygon(index) {
        const {poly, id} = polygons.get(index);
        if(!id) return false;

        const list = JsUtils.toGQLPoints(JsUtils.polygonToList(poly));
        const body = { query: `mutation{updateBoundary(id: ${id}, stateId:1, poly:[${list}])}` };
        return polygon.update.postRequest(Config.api, JSON.stringify(body), {stoken: Config.token});
    }

    function addPolygon(index) {
        polygon.push.index = index;
        const model = polygons.get(index).poly;
        const list = JsUtils.toGQLPoints(JsUtils.polygonToList(model));

        const body = { query: `mutation{createBoundary(stateId:1 poly:[${list}])}` };
        return polygon.push.postRequest(Config.api, JSON.stringify(body), {stoken: Config.token});
    }

    function removePolygon(index) {
        if(index === undefined) return;
        polygon.remove.index = index;
        const body = { query: `mutation{removeBoundaries(idList: [${index}])}` };
        return polygon.remove.postRequest(Config.api, JSON.stringify(body), {stoken: Config.token});
    }

    function fetchPolygons(maxId) {
        print('start:' , maxId);
        const body = { query: `query{boundaries(start:${maxId}){id utc state{name} poly{y x}}}` };
        return polygon.fetch.postRequest(Config.api, JSON.stringify(body), {stoken: Config.token});
    }

    QtObject {
        id: priv
        readonly property var headers: Object({ stoken: Config.token });
        property bool fetching: false
    }

    property QtObject polygon: QtObject {
        property bool running: [fetch, update, push,remove].some(rh => rh.running);

        property RequestHandler update: RequestHandler {
            /// TODO: Gather all fetchs to one file.
            onFinished: function(result) {
                const json = JsUtils.parseJson(result).data;
                if(json === undefined) return;
                const res = json.updateBoundary ?? NaN;

                print(`Updated polygon: ${res}`);
            }
        }

        property RequestHandler push: RequestHandler {
            property int index: -1
            onFinished: function(result) {
                if(!result) return;
                const json = JsUtils.parseJson(result);
                const id = json.qget('data.createBoundary', NaN);
                polygons.setProperty(index, 'id', id);

                print(`Added new polygon (id:${id})`);
            }
        }

        property RequestHandler remove: RequestHandler {
            /// TODO: Gather all fetchs to one file.
            property int index: -1
            onFinished: function(result) {
                if(!result) return;
                const json = JsUtils.parseJson(result);
                const res = json.qget('data.removeBoundaries', NaN);

                print(`Removed polygon (id:${index}): ${res}`);
            }
        }

        property RequestHandler fetch: RequestHandler { /// Fetch data
            onFinished: function(result) {
                const json = JsUtils.parseJson(result);
                if(!json) return;

                const boundaries = json.qget('data.boundaries', []);

                priv.fetching = true;
                boundaries.forEach(function({id, utc, state, poly}) {
                    const mapPoly = poly.map(p => QtPositioning.coordinate(p.y, p.x));
                    polygons.append({ id, poly: mapPoly, utc, state: state.name ?? '' });
                });
                priv.fetching = false;

                print(`Fetched polygons (num:${boundaries.length})`);
            }
        }
    }

    property RequestHandler historyRequest: RequestHandler {
        onFinished: function(result) {
            const history = JsUtils.parseJson(result, {}).qget('data.statusHistory', []);
            if(history) {
                history.forEach(record => {
                    const {id, fieldType, data, utc} = record;
                    events.append(id, fieldType.name, data, utc, fieldType.id);
                });
            }
        }
    }

    property RequestHandler latestDataRequest: RequestHandler {
        onFinished: function(result) {
            const data = JsUtils.parseJson(result, {}).qget('data.latestStatus.data');
            const statuses = JsUtils.parseJson(data, {});

            if(statuses) {
                const parsed = JsUtils.parseStatusData(statuses);
                Object.keys(parsed).forEach(key => {
                    if(control.hasOwnProperty(key)) {
                        control[key] = parsed[key];
                    }
                });
            }
        }
    }

    /// Automated fetch data
    property Timer timer: Timer {
        interval: 60000
        repeat: true; running: true
        triggeredOnStart: true
        onTriggered: {
            const list = Array(polygons.count).fill().map((_,i) => polygons.get(i).id ?? 0);
            const maxId = Math.max(...list, -1);

            fetchPolygons(maxId);
            fetchStatuses();
            fetchLatestStatuses();

            control.lastUpdate = Date.now();
        }
    }

    Binding {
        target: Config
        property: 'processing'
        value: [latestDataRequest, historyRequest, polygon].some(o => o.running)
    }

    Settings {
        fileName: "config.ini"
        category: "Configuration/Status"

        property alias lastUpdate: control.lastUpdate
        property alias location: control.location
    }
}
