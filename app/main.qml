import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.VirtualKeyboard

ApplicationWindow {
    Loader {
        source: "Theme.qml"
        id: themeLoader
    }
    property alias theme: themeLoader.item

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

        //initialItem: allGaugesView
        initialItem: modularView

        Component {
            id: allGaugesView
            Loader { source: "AllGaugesView.qml" }
        }

        Component {
            id: modularView
              RowLayout {
                anchors.fill: parent
                spacing: 10

                // ControlSpace 1
                ControlSpace {
                    id: controlSpace1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    isBeamA: true
                }

                // ControlSpace 2
                ControlSpace {
                    id: controlSpace2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    isBeamA: false
                }
            }
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
        font.pointSize: Math.max(12, parent.height * 0.02)
        width: parent.width * 0.4  // 40% of screen width
        height: parent.height * 0.20  // 30% of screen height
        anchors.centerIn: parent
        onOpened: presetNameField.forceActiveFocus()
        //borderWidth: theme.primaryBorderWidth
        
        background: Rectangle {
            color: theme.secondaryBackgroundColor
        }

        contentItem: Rectangle {
            anchors.fill: parent

            Column {
                anchors.fill: parent
                anchors.margins: parent.height * 0.05  // 5% of dialog height
                spacing: parent.height * 0.05  // 5% of dialog height

                Text {
                    width: parent.width
                    text: "Enter preset name:"
                    color: theme.inactiveTextColor
                    font.pointSize: savePresetDialog.font.pointSize * 1.2
                    horizontalAlignment: Text.AlignHCenter
                }

                TextField {
                    background: Rectangle {
                        color: theme.tertiaryBackgroundColor
                    }
                    id: presetNameField
                    width: parent.width
                    height: parent.height * 0.3  // 20% of column height
                    font.pointSize: savePresetDialog.font.pointSize
                    color: theme.secondaryTextColor
                    placeholderText: "Preset name"
                    focus: true
                    onAccepted: savePresetDialog.accept()
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: parent.width * 0.05  // 5% of column width
                    height: parent.height * 0.3  // 20% of column height

                    Button {
                        background: Rectangle {
                            color: theme.inactiveElementColor
                        }
                        width: parent.parent.width * 0.4  // 40% of column width
                        height: parent.height
                        text: "Save"
                        font.pointSize: savePresetDialog.font.pointSize
                        onClicked: {
                            dmxArray.save_preset(presetNameField.text)
                            savePresetDialog.accept()
                        }
                    }

                    Button {
                        background: Rectangle {
                            color: theme.inactiveElementColor
                        }
                        width: parent.parent.width * 0.4  // 40% of column width
                        height: parent.height
                        text: "Cancel"
                        font.pointSize: savePresetDialog.font.pointSize
                        onClicked: savePresetDialog.reject()
                    }
                }

                Row {
                    InputPanel {
                        id: inputPanel
                        z: 99
                        width: savePresetDialog.width * 0.95
                        height: savePresetDialog.height

                        states: State {
                            name: "visible"
                            when: inputPanel.active
                            PropertyChanges {
                                target: inputPanel
                                y: savePresetDialog.height - inputPanel.height
                            }
                        }
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
        font.pointSize: Math.max(20,parent.height * 0.02)    

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
