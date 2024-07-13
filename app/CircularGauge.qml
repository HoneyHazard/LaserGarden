import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

Item {
    Loader {
        id: themeLoader
        source: "Theme.qml"
    }
    property alias theme: themeLoader.item

    id: root
    width: parent ? parent.width : 150
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
    property color backgroundColor: theme.inactiveElementColor
    property color valueColor: theme.defaultGaugeColor
    property color arrowColor: theme.inactiveElementColor
    property color arrowPressedColor: valueColor
    property color textColor: Qt.darker(valueColor)

    property real arcThickness: 0.2  // As a fraction of the radius
    property real arrowThickness: 0.065  // As a fraction of the width

    signal sigUiChannelChanged(int i, int val)

    onValueChanged: canvas.requestPaint()

    function onDmxChannelChanged(i, newValue) {
        if (i == root.dmxIndex) {
            console.log('gauge index ' + i + ' received value: ' + newValue)
            root.value = newValue
        }
    }

    function sanitizeValue(newValue) {
        this.value = Math.min(this.maxValue, Math.max(this.minValue, newValue))
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

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Canvas {
            id: canvas
            anchors.centerIn: parent
            width: parent.width * 0.8
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

                // Decrease button

                ArrowButton {
                    id: leftArrowButton
                    direction: directionLeft
                    inactiveColor: root.arrowColor
                    pressedColor: root.arrowPressedColor
                    width: parent.width * 0.15
                    height: parent.height * 0.15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.2                  
                    onSigArrowTriggered: {
                        root.value = Math.max(root.minValue, root.value - root.stepSize)
                        sigUiChannelChanged(root.dmxIndex, root.value)
                    }
                }

                // Value display
                Text {
                    text: value
                    color: root.textColor
                    font.pixelSize: parent.width * 0.13
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                // Increase button
                ArrowButton {
                    id: rightArrowButton
                    direction: directionRight
                    inactiveColor: root.arrowColor
                    pressedColor: root.arrowPressedColor
                    width: parent.width * 0.15
                    height: parent.height * 0.15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * 0.2
                    onSigArrowTriggered: {
                        root.value = Math.min(root.maxValue, root.value + root.stepSize)
                        sigUiChannelChanged(root.dmxIndex, root.value)
                    }
                }
            }
        }

        // Title
        Text {
            text: root.title !== "Circular Gauge" ? root.title : (root.dmxIndex !== -1 ? "CH" + root.dmxIndex : root.title)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: canvas.bottom
            font.pixelSize: parent.width * 0.13
            anchors.topMargin: - font.pixelSize * 0.5
            color: root.textColor
        }
    }
}
