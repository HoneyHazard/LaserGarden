import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

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
                onTriggered: savePresetDialog.open()
            }
            MenuItem {
                text: "Load Preset"
                onTriggered: loadPresetDialog.open()
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

    FileDialog {
        id: savePresetDialog
        title: "Save Preset"
        //selectExisting: false
        currentFolder: "file:///mnt/data/projs/LaserGarden/presets"
        nameFilters: ["*.json"]
        fileMode: FileDialog.SaveFile
        onAccepted: {
            dmxArray.save_configuration(savePresetDialog.selectedFile)
        }
    }

    FileDialog {
        id: loadPresetDialog
        title: "Load Preset"
        //selectExisting: true
        currentFolder: "file:///mnt/data/projs/LaserGarden/presets"
        nameFilters: ["*.json"]
        fileMode: FileDialog.OpenFile
        onAccepted: {
            dmxArray.load_configuration(loadPresetDialog.selectedFile)
        }
    }
}
