import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

Item {
    id: root
    width: 150
    height: 150

    property int value: 0
    property int minValue: 0
    property int maxValue: 255
    property real startAngle: -120
    property real endAngle: 120
    property real stepSize: 1
    property int dmxIndex: 0

    signal valueUpdated(int dmxIndex, int newValue)

    function updateValue(newValue) {
        value = Math.min(maxValue, Math.max(minValue, newValue))
    }

    function handleMouseClick(mouseX, mouseY) {
        var centerX = mouseArea.width / 2
        var centerY = mouseArea.height / 2
        var x = mouseX - centerX
        var y = mouseY - centerY
        var angle = Math.atan2(y, x) * 180 / Math.PI + 90

        if (angle < startAngle)
            angle += 360

        if (angle >= startAngle && angle <= endAngle) {
            var newValue = Math.round((angle - startAngle) / (endAngle - startAngle) * (maxValue - minValue) + minValue)
            updateValue(newValue)
            valueUpdated(dmxIndex, newValue)
        }
    }

    onValueChanged: {
        canvas.requestPaint()
        valueUpdated(dmxIndex, value)
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, canvas.width, canvas.height)

            var centerX = canvas.width / 2
            var centerY = canvas.height / 2
            var radius = Math.min(centerX, centerY) - 10
            var angleRange = endAngle - startAngle

            // Draw background arc
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, (startAngle - 90) * Math.PI / 180, (endAngle - 90) * Math.PI / 180)
            ctx.lineWidth = 20
            ctx.strokeStyle = "#ddd"
            ctx.stroke()

            // Draw value arc
            var valueAngle = startAngle + (value - minValue) / (maxValue - minValue) * angleRange
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, (startAngle - 90) * Math.PI / 180, (valueAngle - 90) * Math.PI / 180)
            ctx.lineWidth = 20
            ctx.strokeStyle = "lightblue"
            ctx.stroke()
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: (mouse) => {
            handleMouseClick(mouse.x, mouse.y)
        }
    }

    Text {
        text: value
        anchors.centerIn: parent
        font.pixelSize: 20
    }
}
