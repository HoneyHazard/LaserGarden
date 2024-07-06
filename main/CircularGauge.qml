import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

Item {
    id: root
    width: 200
    height: 200

    property int minValue: 0
    property int maxValue: 255
    property int value: 0
    property int dmxIndex: -1

    function loadValue() {
        if (dmxIndex >= 0 && dmxIndex < 34) {
            value = dmxArray.get_value(dmxIndex)
        }
    }

    function updateValue(newValue) {
        if (dmxIndex >= 0 && dmxIndex < 34) {
            dmxArray.set_value(dmxIndex, newValue)
        }
    }

    Shape {
        anchors.fill: parent
        ShapePath {
            strokeWidth: 10
            strokeColor: "lightgray"
            fillColor: "transparent"
            startX: root.width / 2
            startY: root.height / 2
            PathArc {
                x: root.width / 2
                y: root.height / 2
                radiusX: root.width / 2 - 5
                radiusY: root.height / 2 - 5
                startAngle: 0
                sweepAngle: 360
            }
        }
        ShapePath {
            strokeWidth: 10
            strokeColor: "blue"
            fillColor: "transparent"
            startX: root.width / 2
            startY: root.height / 2
            PathArc {
                x: root.width / 2
                y: root.height / 2
                radiusX: root.width / 2 - 5
                radiusY: root.height / 2 - 5
                startAngle: -90
                sweepAngle: 360 * (root.value - root.minValue) / (root.maxValue - root.minValue)
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: value
        font.pointSize: 20
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.value = (root.value + 1) % (root.maxValue + 1)
            root.updateValue(root.value)
        }
    }

    Connections {
        target: dmxArray
        onValueChanged: {
            if (index === root.dmxIndex) {
                root.loadValue()
            }
        }
    }

    Component.onCompleted: loadValue()
}
