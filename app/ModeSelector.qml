import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: modeSelector
    property alias currentMode: currentModeText.text
    property string layoutDirection: "horizontal" // Can be "horizontal" or "vertical"
    property var modeStrings: [{"display": "Mode1", "internal": "mode1"}, {"display": "Mode2", "internal": "mode2"}, {"display": "Mode3", "internal": "mode3"}]
    property color activeColor: Theme.accentColor
    property color inactiveColor: Theme.baseColor
    property real spacing: 0

    signal sigModeChanged(string newMode)

    Loader {
        id: themeLoader
        source: "Theme.qml"
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: modeSelector.spacing

        Repeater {
            model: modeSelector.modeStrings
            delegate: Rectangle {
                Layout.fillWidth: modeSelector.layoutDirection === "horizontal"
                Layout.fillHeight: modeSelector.layoutDirection === "vertical"
                Layout.preferredWidth: modeSelector.layoutDirection === "horizontal" ? parent.width / modeSelector.modeStrings.length - modeSelector.spacing : parent.width
                Layout.preferredHeight: modeSelector.layoutDirection === "vertical" ? parent.height / modeSelector.modeStrings.length - modeSelector.spacing : parent.height
                color: index === currentModeIndex ? modeSelector.activeColor : modeSelector.inactiveColor
                border.color: Theme.borderColor
                border.width: 1

                Text {
                    id: modeText
                    anchors.centerIn: parent
                    text: modelData.display
                    color: Theme.textColor
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currentModeIndex = index
                        modeSelector.sigModeChanged(modelData.internal)
                    }
                }
            }

            property int currentModeIndex: 0
            onCurrentModeIndexChanged: {
                for (let i = 0; i < count; i++) {
                    itemAt(i).color = i === currentModeIndex ? modeSelector.activeColor : modeSelector.inactiveColor
                }
                currentModeText.text = model.get(currentModeIndex).internal
            }
        }

        // To query the current mode
        Text {
            id: currentModeText
            visible: false
        }
    }
}
