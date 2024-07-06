import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    width: parent.width
    height: parent.height
    color: "lightblue"

    Column {
        spacing: 10
        anchors.centerIn: parent

        Text {
            text: "Welcome to Page 1 with Circular Gauges"
            font.pointSize: 20
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Row {
            spacing: 10

            CircularGauge {
                id: gauge1
                width: 200
                height: 200
                dmxIndex: 0
            }

            CircularGauge {
                id: gauge2
                width: 200
                height: 200
                dmxIndex: 1
            }

            CircularGauge {
                id: gauge3
                width: 200
                height: 200
                dmxIndex: 2
            }
        }

        Row {
            spacing: 10

            CircularGauge {
                id: gauge4
                width: 200
                height: 200
                dmxIndex: 3
            }

            CircularGauge {
                id: gauge5
                width: 200
                height: 200
                dmxIndex: 4
            }

            CircularGauge {
                id: gauge6
                width: 200
                height: 200
                dmxIndex: 5
            }
        }

        Row {
            spacing: 10

            Slider {
                from: 0
                to: 255
                value: gauge1.value
                onValueChanged: gauge1.updateValue(value)
            }

            Slider {
                from: 0
                to: 255
                value: gauge2.value
                onValueChanged: gauge2.updateValue(value)
            }

            Slider {
                from: 0
                to: 255
                value: gauge3.value
                onValueChanged: gauge3.updateValue(value)
            }
        }

        Row {
            spacing: 10

            Slider {
                from: 0
                to: 255
                value: gauge4.value
                onValueChanged: gauge4.updateValue(value)
            }

            Slider {
                from: 0
                to: 255
                value: gauge5.value
                onValueChanged: gauge5.updateValue(value)
            }

            Slider {
                from: 0
                to: 255
                value: gauge6.value
                onValueChanged: gauge6.updateValue(value)
            }
        }
    }
}
