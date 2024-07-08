import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

Item {
    id: root
    width: parent.width
    height: width  // Maintain a 1:1 ratio

    property int value: 0
    property int minValue: 0
    property int maxValue: 255
    property real startAngle: -150
    property real endAngle: 150
    property real stepSize: 1
    property int dmxIndex: -1
    property string title: "Circular Gauge"  // Title property

    // New properties for customization
    property color backgroundColor: "#ccc"
    property color valueColor: "lightblue"
    property color arrowColor: "gray"
    property color arrowPressedColor: "lightblue"
    property real arcThickness: 0.25  // As a fraction of the radius
    property real arrowThickness: 0.065  // As a fraction of the width

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

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Canvas {
            id: canvas
            anchors.centerIn: parent
            width: parent.width * 0.95
            height: width  // Make it square

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, canvas.width, canvas.height)

                var centerX = canvas.width / 2
                var centerY = canvas.height / 2
                var radius = Math.min(centerX, centerY) * 0.9
                var angleRange = endAngle - startAngle

                // Draw background arc
                ctx.beginPath()
                ctx.arc(centerX, centerY, radius, (startAngle - 90) * Math.PI / 180, (endAngle - 90) * Math.PI / 180)
                ctx.lineWidth = radius * arcThickness
                ctx.strokeStyle = backgroundColor
                ctx.stroke()

                // Draw value arc
                var valueAngle = startAngle + (value - minValue) / (maxValue - minValue) * angleRange
                ctx.beginPath()
                ctx.arc(centerX, centerY, radius, (startAngle - 90) * Math.PI / 180, (valueAngle - 90) * Math.PI / 180)
                ctx.lineWidth = radius * arcThickness
                ctx.strokeStyle = valueColor
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

        Column {
            width: parent.width * 0.8
            height: parent.height * 0.8
            anchors.centerIn: parent

            Item {
                width: parent.width
                height: parent.height  // Make it square

                // Decrease button top part
                Rectangle {
                    width: parent.width * 0.13
                    height: parent.width * arrowThickness
                    color: decreaseButtonTop.pressed || decreaseButtonBottom.pressed ? arrowPressedColor : arrowColor
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.23
                    anchors.bottom: parent.verticalCenter
                    anchors.bottomMargin: parent.width * -0.007
                    rotation: -45

                    MouseArea {
                        id: decreaseButtonTop
                        anchors.fill: parent
                        anchors.margins: parent.width * -0.07  // Expands in all directions
                        onPressedChanged: parent.color = decreaseButtonTop.pressed || decreaseButtonBottom.pressed ? arrowPressedColor : arrowColor
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
                    width: parent.width * 0.13
                    height: parent.width * arrowThickness
                    color: decreaseButtonTop.pressed || decreaseButtonBottom.pressed ? arrowPressedColor : arrowColor
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.23
                    anchors.top: parent.verticalCenter
                    anchors.topMargin: parent.width * -0.007
                    rotation: +45

                    MouseArea {
                        id: decreaseButtonBottom
                        anchors.fill: parent
                        anchors.margins: parent.width * -0.07  // Expands in all directions
                        onPressedChanged: parent.color = decreaseButtonTop.pressed || decreaseButtonBottom.pressed ? arrowPressedColor : arrowColor
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
                    font.pixelSize: parent.width * 0.13
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                // Increase button top part
                Rectangle {
                    width: parent.width * 0.13
                    height: parent.width * arrowThickness
                    color: increaseButtonTop.pressed || increaseButtonBottom.pressed ? arrowPressedColor : arrowColor
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * 0.23
                    anchors.bottom: parent.verticalCenter
                    anchors.bottomMargin: parent.width * -0.007
                    rotation: 45

                    MouseArea {
                        id: increaseButtonTop
                        anchors.fill: parent
                        anchors.margins: parent.width * -0.07  // Expands in all directions
                        onPressedChanged: parent.color = increaseButtonTop.pressed || increaseButtonBottom.pressed ? arrowPressedColor : arrowColor
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
                    width: parent.width * 0.13
                    height: parent.width * arrowThickness
                    color: increaseButtonTop.pressed || increaseButtonBottom.pressed ? arrowPressedColor : arrowColor
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * 0.23
                    anchors.top: parent.verticalCenter
                    anchors.topMargin: parent.width * -0.007
                    rotation: -45

                    MouseArea {
                        id: increaseButtonBottom
                        anchors.fill: parent
                        anchors.margins: parent.width * -0.07  // Expands in all directions
                        onPressedChanged: parent.color = increaseButtonTop.pressed || increaseButtonBottom.pressed ? arrowPressedColor : arrowColor
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
            text: root.title !== "Circular Gauge" ? root.title : (root.dmxIndex !== -1 ? "CH" + root.dmxIndex : root.title)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
            font.pixelSize: parent.width * 0.13
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
