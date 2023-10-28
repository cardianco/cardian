//

/**
 * @abstract Return the distance between the input point and the input line.
 * @param {vector2d} point
 * @param {vector2d} start, Start point of line.
 * @param {vector2d} end, End point of line.
 * @returns {Number}, Distance from the point to the middle of line.
 */
function distanceToLine(point, start, end) {
    const [p, p1, p2] = [point, start, end].map(p => Qt.vector2d(p.x, p.y));
    const dir = p2.minus(p1);
    const pdir = Qt.vector2d(dir.y, -dir.x);
    const dToP = p1.minus(p);
    return Math.abs(pdir.normalized().dotProduct(dToP));
}

/**
 * @abstract Returns the distance from the point to the middle of the line.
 * @param {vector2d} point
 * @param {vector2d} start, Start point of line.
 * @param {vector2d} end, End point of line.
 * @returns {Number}, Distance from the point to the middle of line.
 */
function distanceToMid(point, start, end) {
    const [p, p1, p2] = [point, start, end].map(p => Qt.vector2d(p.x, p.y));
    const mid = p1.plus(p2).times(0.5);
    return mid.minus(point).length()
}

/**
 * @abstract Converts snake-case or dash-case to camelCase.
 * @param {String} dash
 * @returns {String} camelCase string.
 */
function toCamelCase(dash) {
    return dash.replace(/[\ _-](\w)/g, (_, c) => c.toUpperCase());
}

/**
 * @abstract Parse JSON and return `undefined` in case of failure.
 * @param {String} json, JSON string
 * @param {*} _default
 * @returns {Object}
 */
export function parseJson(json, _default = undefined) {
    if(!json) return _default;
    try { return JSON.parse(json) }
    catch(e) { return _default; }
}

/**
 * @abstract Convert the point list to a GraphQL-compatible list.
 * @param {String} pointList
 * @returns {String}
 */
export function toGQLPoints(pointList) {
    return pointList.map(v => `{x:${v.x},y:${v.y}}`).join();
}

/**
 * @abstract convert the polygon model to a JavaScript Array list.
 * @param {*} model
 * @returns {Array<vector2d>} List of points.
 */
export function polygonToList(model) {
    return Array(model.count).fill().map(function(_, i) {
        const {longitude, latitude} = model.get(i);
        return Qt.vector2d(longitude, latitude);
    });
}

/**
 * @param {ListModel} model
 * @returns the center of the polygon.
 */
export function polygonCenter(model) {
    const sum = polygonToList(model).reduce((c, p) => c.plus(p), Qt.vector2d(0, 0))
    return sum.times(1/model.count);
}

/**
 * @abstract Find the nearest index to insert the input point.
 * TODO: Move this to a custom polygon model.
 */
export function findNearestPoint(point, model) {
    const list = polygonToList(model);
    const distList = list.map(function(p1, index) {
        const i = (index + 1) % list.length;
        return Object({i, dist: distanceToMid(point, p1, list[i])})
    });

    return distList.reduce((c, line) => c.dist < line.dist ? c : line,
                           {i: 0, dist: Number.MAX_VALUE });
}

export function statusType(key) {
    const types = [
        ['number',   ['speed','temperature','fuel','battery','updown']], // number
        ['boolean',  ['engine','bluetooth','gps','lock','alarm','network']], // boolean
        ['point',    ['location']], // point
        ['vector2d', ['front-light']], // vector2d
        ['vector3d', ['rear-lights']], // vector3d
        ['vector4d', ['doors']], // vector4d
        ['array',    []], // array
    ];

    for(let [type, filter] of types) {
        if(filter.includes(key)) return type;
    }

    return 'object'; // default
}

export function parseStatusData(status) {
    return Object.entries(status).reduce(function(obj, [key, value]) {
        const type = statusType(key);
        const converters = {
            object: v => v, array: v => v, number: v => Number(v), boolean: v => Boolean(v),
            point: v => Qt.point(v[0], v[1]), vector2d: v => Qt.vector2d(v[0], v[1]),
            vector4d: v => Qt.vector3d(v[0], v[1], v[2]),
            vector3d: v => Qt.vector4d(v[0], v[1], v[2], v[3]),
        };

        return Object.assign(obj, {
            [toCamelCase(key)]: converters[type](value)
        });
    }, {});
}

/**
 * @abstract This function determines the status of car doors and returns a corresponding message.
 * @param {vector4d} doors, doors status
 *   x|y
 *   z|w
 */
export function doorsStatus({x,y,z,w}) {
    [x,y,z,w] = [x,y,z,w].map(v => Math.round(v))
    const count = x + y + z + w;
    let front = '', rear = '';

    if(x ^ y) front += 'Front ' + ['right','left'][x];
    else if(x) front += 'Both front';
    if(z ^ w) rear += 'rear ' + ['right','left'][z];
    else if(z) rear += 'both rear';

    return !count ? 'All doors are closed' :
            count === 4 ? 'All doors are open' :
            count === 1 ? `Only ${front || rear} door is open` :
            front && rear ? `${front} and ${rear} doors are open` : `${front || rear} doors are open`;
}

/**
 * @abstract Recursive function which
 * @param {Object} obj
 * @param {*} prefix
 * @returns
 */
export function flattenObject(obj) {
    const flattened = {};

    for (let key in obj) {
        if (obj.hasOwnProperty(key)) {
            if (typeof obj[key] === 'object' && obj[key] !== null) {
                Object.assign(flattened, flattenObject(obj[key]));
            } else {
                flattened[key] = obj[key];
            }
        }
    }

    return flattened;
}
