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

    id: mainWindow
    title: "LaserGarden: " + (dmxArray.Ola002 ? "Olaalite OL-A002" : "Gruolin GL-A001 / Olaalite OL-A003") + " mode"
    visible: true
    width: 1920
    height: 1080

    property bool showTooltipSidebar: pyShowTooltipSidebar
    property bool allGaugesViewMode : !pyModularViewMode

    onAllGaugesViewModeChanged: {
        if (allGaugesViewMode) {
            //console.log("Pushing all gauges view")
            //stackView.push(allGaugesView)   
        } else {
            //console.log("Pushing modular view")
            //stackView.push(modularView)
        }
    }


    function onToolip(val) {
        tooltipSidebar.text = val
    }

    function connectChildItems(item) {
        for (var i = 0; i < item.children.length; i++) {
            var childItem = item.children[i]
            if (childItem.onDmxChannelChanged) {
                //console.log("connected onDmxChannelChanged to " + childItem.name)
                dmxArray.valueChanged.connect(childItem.onDmxChannelChanged)
            }
            if (childItem.sigUiChannelChanged) {
                //console.log("connected sigUiChannelChanged from " + childItem.name)
                childItem.sigUiChannelChanged.connect(dmxArray.set_value)
            }
            if (childItem.children && childItem.children.length > 0) {
                connectChildItems(childItem)
            }
        }
    }

    function rebuildPresetsModel() {
        presetsModel.clear()
        var presets = dmxArray.list_presets()
        for (var i = 0; i < presets.length; i++) {
            presetsModel.append({"name": presets[i]})
        }
    }

    function buildScenesModel(model, beam, group) {
        var scenes = sceneManager.list_scenes_for_beam_and_group(beam, group)
        //var scenes = sceneManager.list_scenes_for_beam(beam)
        for (var i = 0; i < scenes.length; i++) {
            model.append({"name": scenes[i]})
        }
    }

    Component.onCompleted: {
        connectChildItems(stackView)

        rebuildPresetsModel()

        // build models for menus;
        // todo: automate
        buildScenesModel(scenesModelA0, "a", "0")
        buildScenesModel(scenesModelA_star, "a", "*")
        buildScenesModel(scenesModelA1, "a", "1")
        buildScenesModel(scenesModelA2, "a", "2")
        buildScenesModel(scenesModelA3, "a", "3")
        buildScenesModel(scenesModelA4, "a", "4")
        buildScenesModel(scenesModelA5, "a", "5")
        buildScenesModel(scenesModelA6, "a", "6")
        buildScenesModel(scenesModelA8, "a", "8")
        buildScenesModel(scenesModelA12, "a", "12")
        buildScenesModel(scenesModelA_bounds, "a", "bounds")
        buildScenesModel(scenesModelA_other, "a", "other")

        buildScenesModel(scenesModelB0, "b", "0")
        buildScenesModel(scenesModelB_star, "b", "*")
        buildScenesModel(scenesModelB1, "b", "1")
        buildScenesModel(scenesModelB2, "b", "2")
        buildScenesModel(scenesModelB3, "b", "3")
        buildScenesModel(scenesModelB4, "b", "4")
        buildScenesModel(scenesModelB5, "b", "5")
        buildScenesModel(scenesModelB6, "b", "6")
        buildScenesModel(scenesModelB8, "b", "8")
        buildScenesModel(scenesModelB12, "b", "12")
        buildScenesModel(scenesModelB_bounds, "b", "bounds")
        buildScenesModel(scenesModelB_other, "b", "other")

        buildScenesModel(scenesModel_OTHER, "other", '')
        //updateMenus()
    }

    background: Rectangle {
        color: theme.primaryBackgroundColor
    }

    StackView {
        id: stackView
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: (tooltipSidebar.visible ? tooltipSidebar.left : parent.right)
        width: tooltipSidebar.visible ? parent.width * 0.8 : parent.width
        initialItem: allGaugesViewMode ? allGaugesView : modularView
        //initialItem: modularView
        //index: mainWindow.viewModeIndex

        background: Rectangle {
            color: theme.primaryBackgroundColor
        }

        Component {
            id: allGaugesView
            Loader { source: "AllGaugesView.qml" }
        }

        Component {
            id: modularView
            RowLayout {
                //anchors.fill: parent
                spacing: 10

                // ControlSpace 1
                ControlSpace {
                    id: controlSpace1
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true
                    isBeamA: true
                }

                // ControlSpace 2
                ControlSpace {
                    id: controlSpace2
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true
                    isBeamA: false
                }
            }
        }
    }

    Rectangle {
        id: tooltipSidebar
        visible: mainWindow.showTooltipSidebar
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: parent.width * 0.2
        color: theme.tooltipBackgroundColor

        Text {
            id: tooltipText
            color: theme.tooltipTextColor
            font: theme.primaryFont
            text: "Tooltip"
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

        Menu {
            title: qsTr("View")

            // Submenu for View Mode with radio button selection
            Menu {
                title: qsTr("Panel Mode")

                Action {
                    //id: allGaugesMenuAction
                    text: qsTr("All Gauges Mode")
                    checkable: true
                    checked: mainWindow.allGaugesViewMode
                    onTriggered: {
                        //stackView.push(allGaugesView)
                        //mainWindow.viewModeIndex = 0
                        mainWindow.allGaugesViewMode = true
                    }
                }

                Action {
                    //id: modularMenuAction
                    text: qsTr("Modular")
                    checkable: true
                    checked: !mainWindow.allGaugesViewMode
                    onTriggered: {
                        //stackView.push(modularView)
                        //mainWindow.viewModeIndex = 1
                        mainWindow.allGaugesViewMode = false
                    }
                }
            }

            // Checkbox menu item for Tooltip
            Action {
                text: qsTr("Show Tooltip")
                checkable: true
                checked: mainWindow.showTooltipSidebar
                onTriggered: mainWindow.showTooltipSidebar = !mainWindow.showTooltipSidebar
            }
        }

        MenuSeparator {}

        // New Menu for Beam A, Group 0
        Menu {
            title: "A0 (animations)"
  
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

        // New Menu for Beam A, Group *
        Menu {
            title: "A* (circular)"
            Repeater {
                model: scenesModelA_star
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "*", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group 1
        Menu {
            title: "A1 (1-axis)"
            Repeater {
                model: scenesModelA1
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "1", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group 2
        Menu {
            title: "A2"
            Repeater {
                model: scenesModelA2
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "2", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group 3
        Menu {
            title: "A3"
            Repeater {
                model: scenesModelA3
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "3", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group 4
        Menu {
            title: "A4"
            Repeater {
                model: scenesModelA4
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "4", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group 5
        Menu {
            title: "A5"
            Repeater {
                model: scenesModelA5
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "5", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group 6
        Menu {
            title: "A6"
            Repeater {
                model: scenesModelA6
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "6", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group 8
        Menu {
            title: "A8"
            Repeater {
                model: scenesModelA8
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "8", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group 12
        Menu {
            title: "A12"
            Repeater {
                model: scenesModelA12
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "12", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group Bounds
        Menu {
            title: "A_bounds"
            Repeater {
                model: scenesModelA_bounds
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "bounds", name)
                    }
                }
            }
        }

        // New Menu for Beam A, Group Other
        Menu {
            title: "A_other"
            Repeater {
                model: scenesModelA_other
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("a", "other", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group 0
        Menu {
            title: "B0 (animations)"
            Repeater {
                model: scenesModelB0
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "0", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group *
        Menu {
            title: "B* (circular)"
            Repeater {
                model: scenesModelB_star
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "*", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group 1
        Menu {
            title: "B1 (1 axis)"
            Repeater {
                model: scenesModelB1
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "1", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group 2
        Menu {
            title: "B2"
            Repeater {
                model: scenesModelB2
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "2", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group 3
        Menu {
            title: "B3"
            Repeater {
                model: scenesModelB3
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "3", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group 4
        Menu {
            title: "B4"
            Repeater {
                model: scenesModelB4
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "4", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group 6
        Menu {
            title: "B6"
            Repeater {
                model: scenesModelB6
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "6", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group 8
        Menu {
            title: "B8"
            Repeater {
                model: scenesModelB8
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "8", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group 12
        Menu {
            title: "B12"
            Repeater {
                model: scenesModelB12
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "12", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group Bounds
        Menu {
            title: "B_bounds"
            Repeater {
                model: scenesModelB_bounds
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "bounds", name)
                    }
                }
            }
        }

        // New Menu for Beam B, Group Other
        Menu {
            title: "B_other"
            Repeater {
                model: scenesModelB_other
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_scene("b", "other", name)
                    }
                }
            }
        }
            
        // New Menu for OTHER
        Menu {
            title: "<i>OTHER</i>"
            Repeater {
                model: scenesModel_OTHER
                delegate: MenuItem {
                    text: name
                    onTriggered: {
                        // Load the selected scene
                        dmxArray.load_other_scene(name)
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
                            mainWindow.rebuildPresetsModel()
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

    // Scene Models for Menus
    ListModel { id: scenesModelA0 }
    ListModel { id: scenesModelA_star }
    ListModel { id: scenesModelA1 }
    ListModel { id: scenesModelA2 }
    ListModel { id: scenesModelA3 }
    ListModel { id: scenesModelA4 }
    ListModel { id: scenesModelA5 }
    ListModel { id: scenesModelA6 }
    ListModel { id: scenesModelA8 }
    ListModel { id: scenesModelA12 }
    ListModel { id: scenesModelA_other }
    ListModel { id: scenesModelA_bounds }

    ListModel { id: scenesModelB0 }
    ListModel { id: scenesModelB_star }
    ListModel { id: scenesModelB1 }
    ListModel { id: scenesModelB2 }
    ListModel { id: scenesModelB3 }
    ListModel { id: scenesModelB4 }
    ListModel { id: scenesModelB5 }
    ListModel { id: scenesModelB6 }
    ListModel { id: scenesModelB8 }
    ListModel { id: scenesModelB12 }
    ListModel { id: scenesModelB_other }
    ListModel { id: scenesModelB_bounds }

    ListModel { id: scenesModel_OTHER }
    
}
