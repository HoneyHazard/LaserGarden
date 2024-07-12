import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    Loader {
        id: themeLoader
        source: "Theme.qml"
    }
    property alias theme: themeLoader.item

    id: page
    Rectangle {
        anchors.fill: parent
        color: theme.primaryBackgroundColor
    }

    GridLayout {
        id: grid
        rows : 3
        columns: 9
        anchors.fill: parent
        anchors.margins: 0

        CircularGauge {
            id: mainSwitchGauge
            title: "SW A"
            valueColor: theme.mainBeamColorA
            //arrowPressedColor: theme.mainBeamColorA
            dmxIndex: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: gauge2
            dmxIndex: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: gauge3
            dmxIndex: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: gauge4
            dmxIndex: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: gauge5
            dmxIndex: 4
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: gauge6
            dmxIndex: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Component.onCompleted: {
        connectChildItems(page)
    }
}
