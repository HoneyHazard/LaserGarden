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
            startX: width / 2
            startY: height / 2
            PathArc {
                direction: PathArc.Clockwise
                radiusX: width / 2 - 10
                radiusY: height / 2 - 10
                x: width / 2
                y: height / 2
                useLargeArc: false
                relativeX: 0
                relativeY: 0
                xAxisRotation: 0
            }
        }
        ShapePath {
            strokeWidth: 10
            strokeColor: "blue"
            fillColor: "transparent"
            startX: width / 2
            startY: height / 2
            PathArc {
                direction: PathArc.Clockwise
                radiusX: width / 2 - 10
                radiusY: height / 2 - 10
                x: width / 2 + (width / 2 - 10) * Math.cos(2 * Math.PI * (value - minValue) / (maxValue - minValue) - Math.PI / 2)
                y: height / 2 + (height / 2 - 10) * Math.sin(2 * Math.PI * (value - minValue) / (maxValue - minValue) - Math.PI / 2)
                useLargeArc: (value - minValue) / (maxValue - minValue) > 0.5
                relativeX: 0
                relativeY: 0
                xAxisRotation: 0
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
            root.value = (root.value + 1) % (root.maxValue + 1);
            root.updateValue(root.value);
        }
    }

    Connections {
        target: dmxArray
        function onValueChanged(index, value) {
            if (index === root.dmxIndex) {
                root.value = value;
            }
        }
    }

    Component.onCompleted: loadValue()
}
