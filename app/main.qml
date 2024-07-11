import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "LaserGarden"

    function connectChildItems(item) {
        for (var i = 0; i < item.children.length; i++) {
            var childItem = item.children[i]
            if (childItem.onDmxChannelChanged) {
                dmxArray.valueChanged.connect(childItem.onDmxChannelChanged)
            }
            if (childItem.sigUiChannelChanged) {
                childItem.sigUiChannelChanged.connect(dmxArray.set_value)
            }
            if (childItem.children && childItem.children.length > 0) {
                connectChildItems(childItem)
            }
        }
    }

    Component.onCompleted: {
        connectChildItems(stackView)

        var presets = dmxArray.list_presets()
        for (var i = 0; i < presets.length; i++) {
            presetsModel.append({"name": presets[i]})
        }

        // Load scenes for Beam A, Group 0
        var scenesA0 = sceneManager.list_scenes_for_beam_and_group("a", "0")
        for (var i = 0; i < scenesA0.length; i++) {
            scenesModelA0.append({"name": scenesA0[i]})
        }
    }

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
                onTriggered: {
                    presetNameField.text = ""
                    savePresetDialog.open()
                }
            }
            MenuItem {
                text: "Load Preset"
                onTriggered: loadPresetDialog.open
            }
        }

        // New Menu for Beam A, Group 0
        Menu {
            title: "A0"
            Repeater {
                model: scenesModelA0
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "0", name)
                    }
                }
            }
        }
    }

    Dialog {
        id: savePresetDialog
        visible: false
        modal: true
        focus: true
        title: "Save Preset"

        Column {
            width: parent.width
            height: parent.height

            TextField {
                id: presetNameField
                placeholderText: "Enter preset name"
                width: parent.width
            }

            Row {
                spacing: 10
                Button {
                    text: "Save"
                    onClicked: {
                        dmxArray.save_preset(presetNameField.text)
                        savePresetDialog.close()
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
        visible: false
        modal: true
        focus: true
        title: "Load Preset"

        Column {
            width: parent.width
            height: parent.height

            ScrollView {
                width: parent.width
                height: parent.height * 0.8

                GridView {
                    id: presetGridView
                    model: presetsModel
                    cellWidth: 120
                    cellHeight: 50
                    width: parent.width
                    height: parent.height

                    delegate: Item {
                        width: presetGridView.cellWidth
                        height: presetGridView.cellHeight

                        Rectangle {
                            width: presetGridView.cellWidth
                            height: presetGridView.cellHeight
                            color: "lightgray"
                            border.color: "black"
                            radius: 5

                            RowLayout {
                                anchors.fill: parent
                                Label {
                                    text: name
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
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

    // New Model for Scenes A0
    ListModel {
        id: scenesModelA0
    }
}
