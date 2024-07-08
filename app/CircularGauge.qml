import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

Item {
    id: root
    width: 150
    height: 200  // Adjusted height to accommodate title

    property int value: 0
    property int minValue: 0
    property int maxValue: 255
    property real startAngle: -150
    property real endAngle: 150
    property real stepSize: 1
    property int dmxIndex: -1
    property string title: "Circular Gauge"  // Title property

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

    Column {
        anchors.fill: parent

        // Gauge and Spinbox buttons
        Item {
            width: parent.width
            height: parent.height - 40  // Adjust height to accommodate title

            Canvas {
                id: canvas
                anchors.centerIn: parent
                width: parent.width
                height: parent.width  // Make it square

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
                    ctx.strokeStyle = "#ccc"
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

            Item {
                width: parent.width
                height: parent.width  // Make it square

                // Decrease button top part
                Rectangle {
                    width: 20
                    height: 10
                    color: decreaseButtonTop.pressed || decreaseButtonBottom.pressed ? "lightblue" : "#ccc"
                    anchors.left: parent.left
                    anchors.leftMargin: 35
                    anchors.bottom: parent.verticalCenter
                    anchors.bottomMargin: -1
                    rotation: -45

                    MouseArea {
                        id: decreaseButtonTop
                        anchors.fill: parent
                        anchors.margins: -10 // Expands 10 pixels in all directions
                        onPressedChanged: parent.color = decreaseButtonTop.pressed || decreaseButtonBottom.pressed ? "lightblue" : "#ccc"
                        onPressed: {
                            root.value = Math.max(root.minValue, root.value - root.stepSize)
                            sigUiChannelChanged(root.dmxIndex, root.value)
                            decreaseDelayTimer.start()
                        }
                        onReleased: {
                            decreaseTimer.stop()
                            decreaseDelayTimer.stop()
                        }
                        onClicked: {
                            root.value = Math.max(root.minValue, root.value - root.stepSize)
                            sigUiChannelChanged(root.dmxIndex, root.value)
                        }
                    }
                }
                // Decrease button bottom part
                Rectangle {
                    width: 20
                    height: 10
                    color: decreaseButtonTop.pressed || decreaseButtonBottom.pressed ? "lightblue" : "#ccc"
                    anchors.left: parent.left
                    anchors.leftMargin: 35
                    anchors.top: parent.verticalCenter
                    anchors.topMargin: -1
                    rotation: +45

                    MouseArea {
                        id: decreaseButtonBottom
                        anchors.fill: parent
                        anchors.margins: -10 // Expands 10 pixels in all directions
                        onPressedChanged: parent.color = decreaseButtonTop.pressed || decreaseButtonBottom.pressed ? "lightblue" : "#ccc"
                        onPressed: {
                            root.value = Math.max(root.minValue, root.value - root.stepSize)
                            sigUiChannelChanged(root.dmxIndex, root.value)
                            decreaseDelayTimer.start()
                        }
                        onReleased: {
                            decreaseTimer.stop()
                            decreaseDelayTimer.stop()
                        }
                        onClicked: {
                            root.value = Math.max(root.minValue, root.value - root.stepSize)
                            sigUiChannelChanged(root.dmxIndex, root.value)
                        }
                    }
                }

                // Value display
                Text {
                    text: value
                    font.pixelSize: 20
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                // Increase button top part
                Rectangle {
                    width: 20
                    height: 10
                    color: increaseButtonTop.pressed || increaseButtonBottom.pressed ? "lightblue" : "#ccc"
                    anchors.right: parent.right
                    anchors.rightMargin: 35
                    anchors.bottom: parent.verticalCenter
                    anchors.bottomMargin: -1
                    rotation: 45

                    MouseArea {
                        id: increaseButtonTop
                        anchors.fill: parent
                        anchors.margins: -10 // Expands 10 pixels in all directions
                        onPressedChanged: parent.color = increaseButtonTop.pressed || increaseButtonBottom.pressed ? "lightblue" : "#ccc"
                        onPressed: {
                            root.value = Math.min(root.maxValue, root.value + root.stepSize)
                            sigUiChannelChanged(root.dmxIndex, root.value)
                            increaseDelayTimer.start()
                        }
                        onReleased: {
                            increaseTimer.stop()
                            increaseDelayTimer.stop()
                        }
                        onClicked: {
                            root.value = Math.min(root.maxValue, root.value + root.stepSize)
                            sigUiChannelChanged(root.dmxIndex, root.value)
                        }
                    }
                }
                // Increase button bottom part
                Rectangle {
                    width: 20
                    height: 10
                    color: increaseButtonTop.pressed || increaseButtonBottom.pressed ? "lightblue" : "#ccc"
                    anchors.right: parent.right
                    anchors.rightMargin: 35
                    anchors.top: parent.verticalCenter
                    anchors.topMargin: -1
                    rotation: -45

                    MouseArea {
                        id: increaseButtonBottom
                        anchors.fill: parent
                        anchors.margins: -10 // Expands 10 pixels in all directions
                        onPressedChanged: parent.color = increaseButtonTop.pressed || increaseButtonBottom.pressed ? "lightblue" : "#ccc"
                        onPressed: {
                            root.value = Math.min(root.maxValue, root.value + root.stepSize)
                            sigUiChannelChanged(root.dmxIndex, root.value)
                            increaseDelayTimer.start()
                        }
                        onReleased: {
                            increaseTimer.stop()
                            increaseDelayTimer.stop()
                        }
                        onClicked: {
                            root.value = Math.min(root.maxValue, root.value + root.stepSize)
                            sigUiChannelChanged(root.dmxIndex, root.value)
                        }
                    }
                }
            }
        }

        // Title
        Text {
            text: root.title
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 20
            color: "#000000"
        }
    }

    Timer {
        id: decreaseDelayTimer
        interval: 600
        onTriggered: {
            decreaseDelayTimer.stop()
            decreaseTimer.start()
        }
    }

    Timer {
        id: decreaseTimer
        interval: 100
        repeat: true
        onTriggered: {
            root.value = Math.max(root.minValue, root.value - root.stepSize)
            sigUiChannelChanged(root.dmxIndex, root.value)
        }
    }

    Timer {
        id: increaseDelayTimer
        interval: 600
        onTriggered: {
            increaseDelayTimer.stop()
            increaseTimer.start()
        }
    }

    Timer {
        id: increaseTimer
        interval: 100
        repeat: true
        onTriggered: {
            root.value = Math.min(root.maxValue, root.value + root.stepSize)
            sigUiChannelChanged(root.dmxIndex, root.value)
        }
    }
}
