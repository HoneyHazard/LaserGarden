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
    property int dmxIndex: -1

    signal sigUiChannelChanged(int dmxIndex, int newValue)

    function onDmxChannelChanged(dmxIndex, newValue) {
        if (dmxIndex == this.dmxIndex) {
            console.log('UI element received DMX value: ' + dmxIndex + ' changed to ' + newValue)
            value = newValue
        }
    }

    function sanitizeValue(newValue) {
        value = Math.min(maxValue, Math.max(minValue, newValue))
    }

    function onMouseInteraction(mouseX, mouseY) {
        var centerX = mouseArea.width / 2
        var centerY = mouseArea.height / 2
        var x = mouseX - centerX
        var y = mouseY - centerY
        var angle = Math.atan2(y, x) * 180 / Math.PI

        // Normalize the angle to be between 0 and 360 degrees
        angle = (angle + 360 + 90) % 360

        // Ensure the start and end angles are positive and normalized
        var start = (startAngle + 360) % 360
        var end = (endAngle + 360) % 360

        // Check if the angle is within the valid range
        if ((start < end && angle >= start && angle <= end) || (start > end && (angle >= start || angle <= end))) {
            var newValue = Math.round(((angle - start + 360) % 360) / (end - start + (end < start ? 360 : 0)) * (maxValue - minValue) + minValue)
            sanitizeValue(newValue)
            
            console.log('UI element emitting DMX value: ' + dmxIndex + ' changed to ' + newValue)
            sigUiChannelChanged(dmxIndex, newValue)
        }
    }

    onValueChanged: {
        canvas.requestPaint()
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
            onMouseInteraction(mouse.x, mouse.y)
        }

        onPositionChanged: (mouse) => {
            if (mouse.buttons & Qt.LeftButton) {
                onMouseInteraction(mouse.x, mouse.y)
            }
        }

        onPressed: (mouse) => {
            onMouseInteraction(mouse.x, mouse.y)
        }
    }

    Text {
        text: value
        anchors.centerIn: parent
        font.pixelSize: 20
    }

    /*     
    Connections {
        target: parent
        function onDmxChannelChanged(dmxIndex, newValue) {
            if (dmxIndex == this.dmxIndex) {
                value = newValue
            }
        }
    }
 */
}

