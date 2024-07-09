import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: arrowButton
    property color color: "gray"
    property color pressedColor: "lightblue"
    property bool pressed: false
    property real aspectRatio: 1  // Ensuring a 1:1 aspect ratio (width / height)
    
    readonly property int directionLeft: 0
    readonly property int directionRight: 1
    readonly property int directionUp: 2
    readonly property int directionDown: 3

    property int direction: directionLeft

    signal sigArrowTriggered()

    // Adjust width and height to fill the available space while maintaining aspect ratio
    readonly property real sz: 1.4 * Math.min(width, height)
    
    //readonly property real targetWidth: Math.min(parent ? parent.width : width, (parent ? parent.height : height) * aspectRatio)
    //readonly property real targetHeight: targetWidth / aspectRatio

    readonly property color strokeStyle: arrowButton.pressed ? arrowButton.pressedColor : arrowButton.color


    width: targetWidth
    height: targetHeight

    Rectangle {
        anchors.fill: parent
        color: "magenta"
    }

    Canvas {
        id: canvas
        anchors.centerIn: parent

        property real lineW: sz / 5
        width: parent.width
        height: parent.height  // Make it square

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, canvas.width, canvas.height)

            var halfSz = arrowButton.sz / 2
            var centerX = canvas.width / 2
            var centerY = canvas.height / 2
            var lineW = sz / 6
            
            ctx.lineWidth = lineW
            ctx.strokeStyle = arrowButton.pressed ? arrowButton.pressedColor : arrowButton.color
            ctx.beginPath()
            if (arrowButton.direction == arrowButton.directionLeft) {
                ctx.moveTo(centerX - halfSz + lineW, centerY + lineW/4)
                ctx.lineTo(centerX + halfSz - lineW/2, centerY + halfSz - lineW)
                ctx.moveTo(centerX - halfSz + lineW, centerY - lineW/4)
                ctx.lineTo(centerX + halfSz - lineW/2, centerY - halfSz + lineW)
                
                ctx.moveTo(centerX - halfSz + lineW, centerY + lineW/1.4)
                ctx.lineTo(centerX - halfSz + lineW, centerY - lineW/1.4)
            } else if (arrowButton.direction == arrowButton.directionRight) {
                ctx.moveTo(centerX + halfSz - lineW, centerY + lineW/4)
                ctx.lineTo(centerX - halfSz + lineW/2, centerY + halfSz - lineW)
                ctx.moveTo(centerX + halfSz - lineW, centerY - lineW/4)
                ctx.lineTo(centerX - halfSz + lineW/2, centerY - halfSz + lineW)
                
                ctx.moveTo(centerX + halfSz - lineW, centerY + lineW/1.4)
                ctx.lineTo(centerX + halfSz - lineW, centerY - lineW/1.4)
            } else if (arrowButton.direction == arrowButton.directionUp) {
                ctx.moveTo(centerX + lineW/4, centerY - halfSz + lineW)
                ctx.lineTo(centerX + halfSz - lineW, centerY + halfSz - lineW)
                ctx.moveTo(centerX - lineW/4, centerY - halfSz + lineW)
                ctx.lineTo(centerX - halfSz + lineW, centerY + halfSz - lineW)
                
                ctx.moveTo(centerX + lineW/1.4, centerY - halfSz + lineW)
                ctx.lineTo(centerX - lineW/1.4, centerY - halfSz + lineW)
            } else if (arrowButton.direction == arrowButton.directionDown) {
                ctx.moveTo(centerX + lineW/4, centerY + halfSz - lineW)
                ctx.lineTo(centerX + halfSz - lineW, centerY - halfSz + lineW)
                ctx.moveTo(centerX - lineW/4, centerY + halfSz - lineW)
                ctx.lineTo(centerX - halfSz + lineW, centerY - halfSz + lineW)
                
                ctx.moveTo(centerX + lineW/1.4, centerY + halfSz - lineW)
                ctx.lineTo(centerX - lineW/1.4, centerY + halfSz - lineW)
            }
            ctx.stroke()

        }
    }


/*
    Rectangle {
        id: topRect
        width: 1.4*sz/2
        height: 5
        //color: arrowButton.pressed ? arrowButton.pressedColor : arrowButton.color
        color: "red"
        anchors.bottomMargin: -0.1 * height
        rotation: -45
        anchors.bottom: parent.verticalCenter 
        anchors.horizontalCenter: parent.horizontalCenter

    }

    Rectangle {
        id: bottomRect
        width: 1.4*sz/2
        height: 5
        //anchors.topMargin: -0.1 * height
        color: arrowButton.pressed ? arrowButton.pressedColor : arrowButton.color
        rotation: +45
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter

    }
    */

    MouseArea {
        anchors.fill: parent
        anchors.margins: -width * 0.1  // Slightly expanded bounding box
        onPressed: {
            arrowButton.pressed = true
            holdDelayTimer.start()
            canvas.requestPaint()
        }
        onReleased: {
            arrowButton.pressed = false
            holdTimer.stop()
            holdDelayTimer.stop()
            canvas.requestPaint()
        }
        onClicked: {
            sigArrowTriggered()
        }
    }

    Timer {
        id: holdDelayTimer
        interval: 400
        onTriggered: {
            holdDelayTimer.stop()
            holdTimer.start()
        }
    }

    Timer {
        id: holdTimer
        interval: 100
        repeat: true
        onTriggered: {
            sigArrowTriggered()
        }
    }
}
