import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: arrowButton
    property color color: "gray"
    property color pressedColor: "lightblue"
    property bool pressed: false
    property real widthRatio: 0.13
    property real heightRatio: 0.065

    signal sigArrowTrigered()

    width: parent ? parent.width * widthRatio : 20
    height: parent ? parent.width * heightRatio : 10

    Rectangle {
        id: topRect
        width: arrowButton.width
        height: arrowButton.height
        color: arrowButton.pressed ? arrowButton.pressedColor : arrowButton.color
        anchors.bottom: parent.verticalCenter 
        anchors.bottomMargin: -0.1 * height
        rotation: -45
    }

    Rectangle {
        id: bottomRect
        width: arrowButton.width
        height: arrowButton.height
        anchors.top: parent.verticalCenter
        anchors.topMargin: -0.1 * height
        color: arrowButton.pressed ? arrowButton.pressedColor : arrowButton.color
        rotation: +45
    }

    MouseArea {
        anchors.fill: parent
        anchors.margins: -width * 0.1  // Slightly expanded bounding box
        onPressed: {
            arrowButton.pressed = true
            holdDelayTimer.start()
        }
        onReleased: {
            arrowButton.pressed = false
            holdTimer.stop()
            holdDelayTimer.stop()
        }
        onClicked: {
            sigArrowTrigered()
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
            sigArrowTrigered()
        }
    }
}
