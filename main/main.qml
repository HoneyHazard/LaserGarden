import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "LaserGarden"

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: page1

        Component {
            id: page1
            Loader { source: "Page1.qml" }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "File"
            MenuItem {
                text: "Save Preset"
                onTriggered: dmxArray.save_preset()
            }
            MenuItem {
                text: "Load Preset"
                onTriggered: dmxArray.load_preset()
            }
            MenuItem {
                text: "Save as Default"
                onTriggered: dmxArray.save_default()
            }
            MenuItem {
                text: "Load Default"
                onTriggered: dmxArray.load_default()
            }
            MenuItem {
                text: "Quit"
                onTriggered: Qt.quit()
            }
        }
    }
}
