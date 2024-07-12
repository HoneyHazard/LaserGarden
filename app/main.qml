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
                onTriggered: loadPresetDialog.open()
            }
            MenuSeparator {}
            MenuItem {
                text: "Save As Default"
                onTriggered: dmxArray.save_default()
            }
            MenuItem {
                text: "Load Default"
                onTriggered: dmxArray.load_default()
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
        modal: true
        focus: true
        title: "Save Preset"
        font.pointSize: parent.height * 0.02
        
        width: parent.width * 0.5
        height: parent.height * 0.3
        anchors.centerIn: parent       

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height * 0.8

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
                        onClicked: savePresetDialog.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: loadPresetDialog
        modal: true
        focus: true
        title: "Load Preset"
        width: parent.width * 0.93
        height: parent.height * 0.9
        anchors.centerIn: parent   
        font.pointSize: parent.height * 0.02    

        Rectangle {
            anchors.centerIn: parent
            height: parent.height
            width: parent.width 

            Rectangle{
                width: parent.width
                height: parent.height * 0.9
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                ScrollView {
                    id: presetScrollView
                    width: parent.width
                    height: parent.height
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                    GridView {
                        id: presetGridView
                        model: presetsModel
                        cellWidth: presetScrollView.width / 3
                        cellHeight: presetScrollView.height / 15
                        width: parent.width
                        height: parent.height

                        delegate: Item {
                            width: presetGridView.cellWidth * 0.9
                            height: presetGridView.cellHeight * 0.9

                            Rectangle {
                                width: presetGridView.cellWidth * 0.95
                                height: presetGridView.cellHeight * 0.9
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
                                        wrapMode: Text.WordWrap
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
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.95
                height: parent.height * 0.1
                id: loadPresetDialogButtons
                Button {
                    height: parent.height * 0.8
                    width: parent.width / 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                    text: "Cancel"
                    onClicked: loadPresetDialog.close()
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
