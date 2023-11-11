import QtQuick 2.15
import QtQuick.Controls 2.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

import cardian.core 0.1

BasePage {
    id: page

    property real bwidth: 65

    component ActionButton: TriStateButton {
        property RequestHandler request: RequestHandler {}
        property var command: undefined
        property bool active: false

        clip: true
        font: Fonts.btnicon
        state: Object.keys(request.running).length ?
                   TriStateButton.Indeterminate : active

        onClicked: {
            if(command) {
                var cmd = {
                    query :'mutation{sendCommand(value:"' + JSON.stringify(command).replace(/"/g,'\\"') + '",fieldId:1)}'
                }
                var res = request.postRequest(Config.api, JSON.stringify(cmd), {stoken: Config.token});
                console.info('command:', JSON.stringify(command))
            }
        }

        Binding {
            target: Config; property: 'processing';
            value: Object.keys(request.running).length
        }
    }

    contentItem: Item {
        CarView {
            id: carview
            x: (parent.width - width)/2

            width: 250; height: Math.min(page.height - actions.height - 60, 500)
            strokeWidth: 2

            doors: Status.doors.times(35)
            frontLights: Status.frontLights

            source: 'qrc:/resources/images/mazda-6-2019.svg'
        }

        QGrid {
            id: actions

            x: (parent.width - width)/2
            y: parent.height - height

            width: childrenRect.width
            vertical: true

            QGrid {
                vertical: true
                spacing: -page.bwidth/2 + 5

                Row {
                    spacing: bwidth/2

                    ActionButton {
                        active: Status.bluetooth
                        text: active ? '\ue031' : '\ue033'
                        command: {'bluetooth': !active}
                    }

                    ActionButton {
                        active: Status.engine
                        text: active ? '\ue090' : '\ue091'
                        command: {'engine': !active}
                    }

                    ActionButton {
                        active: Status.doors.x
                        text: active ? '\ue063' : '\ue061'
                        command: {'doors': Array(4).fill(Number(!active))}
                    }
                }

                Row {
                    spacing: bwidth/2

                    ActionButton {
                        active: Status.frontLights.x
                        text: active ? '\ue170' : '\ue173'
                        command: {'front-lights': Array(2).fill(Number(!active))}
                    }

                    ActionButton {
                        active: Status.alarm
                        text: active ? '\ue036' : '\ue037'
                        command: {'alarm': !active}
                    }
                }
            }
        }
    }
}
