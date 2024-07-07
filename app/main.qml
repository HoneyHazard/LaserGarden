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
            
            // Process the child item here
            //console.log("Child:", childItem)
            
            // Access properties of the child if needed
            //if (childItem.objectName) {
            //    console.log("Object Name:", childItem.objectName)
            //}
            
            if (childItem.onDmxChannelChanged) {
                console.log("Setting up DMX channel handler for dmx channel: " + childItem.dmxIndex)
                dmxArray.valueChanged.connect(childItem.onDmxChannelChanged)
            }
            if (childItem.sigUiChannelChanged) {
                console.log("Setting up UI channel handler for: " + childItem)
                childItem.sigUiChannelChanged.connect(dmxArray.set_value)
            }

            // Recursively iterate through the child's children
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
                    presetNameField.focus = true
                }
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
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 400
        height: 200

        Column {
            spacing: 10
            Label {
                text: "Enter preset name:"
            }
            TextField {
                id: presetNameField
                placeholderText: "Preset name"
                width: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
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
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 500
        height: 400

        Column {
            spacing: 10
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
}
