import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

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
                text: "Reset"
                onTriggered: dmxArray.reset()
            }
            MenuItem {
                text: "Quit"
                onTriggered: Qt.quit()
            }
        }
    }

    Dialog {
        id: savePresetDialog
        modal: true
        title: "Save Preset"

        Column {
            spacing: 10
            Label {
                text: "Enter preset name:"
            }
            TextField {
                id: presetNameField
                placeholderText: "Preset name"
            }
            Row {
                spacing: 10
                Button {
                    text: "Save"
                    onClicked: {
                        if (presetNameField.text.length > 0) {
                            dmxArray.save_configuration("presets/" + presetNameField.text + ".json")
                            savePresetDialog.close()
                        }
                    }
                }
                Button {
                    text: "Cancel"
                    onClicked: savePresetDialog.close
                }
            }
        }
    }

    Dialog {
        id: loadPresetDialog
        modal: true
        title: "Load Preset"

        Column {
            spacing: 10
            width: parent.width
            height: parent.height

            ListView {
                id: presetListView
                model: presetsModel
                width: parent.width
                height: parent.height * 0.8

                delegate: Item {
                    width: presetListView.width
                    height: 40

                    RowLayout {
                        width: parent.width
                        height: parent.height
                        Label {
                            text: name
                            Layout.fillWidth: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            dmxArray.load_configuration("presets/" + name + ".json")
                            loadPresetDialog.close()
                        }
                    }
                }
            }
            Row {
                spacing: 10
                Button {
                    text: "Cancel"
                    onClicked: loadPresetDialog.close
                }
            }
        }
    }

    ListModel {
        id: presetsModel
    }

    Component.onCompleted: {
        var presets = dmxArray.list_presets()
        for (var i = 0; i < presets.length; i++) {
            presetsModel.append({"name": presets[i]})
        }
    }
}
