import QtQuick 2.15

ShaderEffect {
    id: control

    property alias running: timer.running
    property color color: '#23a8f2'
    property real time: 10
    readonly property vector2d ratio: {
        const w = Math.max(width, height);
        return Qt.vector2d(width/w, height/w);
    }

    fragmentShader: "qrc:/cardian/controls/shaders/plasma.frag"

    Timer {
        id: timer
        interval: 1000/40; repeat: true
        onTriggered: parent.time += .005
        running: true
    }
}
