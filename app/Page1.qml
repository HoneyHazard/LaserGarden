import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: page

    GridLayout {
        id: grid
        columns: 3
        anchors.fill: parent
        anchors.margins: 0

        CircularGauge {
            id: gauge1
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
