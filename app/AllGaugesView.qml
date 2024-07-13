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
        rows: 3
        columns: 9
        anchors.fill: parent
        anchors.margins: 0

        CircularGauge {
            id: mainSwitchA
            title: "SW A"
            valueColor: theme.mainBeamColorA
            dmxIndex: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: sizeAndOobA
            title: "SIZE & OOB"
            valueColor: theme.mainBeamColorA
            dmxIndex: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: patternTypeGaugeA
            title: "PATT TYPE"
            valueColor: theme.mainBeamColorA
            dmxIndex: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: patternSelectA
            title: "PATT SEL"
            valueColor: theme.mainBeamColorA
            dmxIndex: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: scaleA
            title: "SCALE"
            valueColor: theme.mainBeamColorA
            dmxIndex: 4
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: orientA
            title: "ORIENT"
            valueColor: theme.mainBeamColorA
            dmxIndex: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: horizShiftA
            title: "SHFT HORIZ"
            valueColor: theme.mainBeamColorA
            dmxIndex: 6
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: vertShiftA
            title: "SHFT VERT"
            valueColor: theme.mainBeamColorA
            dmxIndex: 7
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: horizZoomA
            title: "ZOOM HORIZ"
            valueColor: theme.mainBeamColorA
            dmxIndex: 8
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: vertZoomA
            title: "ZOOM VERT"
            valueColor: theme.mainBeamColorA
            dmxIndex: 9
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: colorShiftA
            title: "CLR SHIFT"
            valueColor: theme.mainBeamColorA
            dmxIndex: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: colorA
            title: "COLOR"
            valueColor: theme.mainBeamColorA
            dmxIndex: 11
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: nodeA
            title: "SCAN"
            valueColor: theme.mainBeamColorA
            dmxIndex: 12
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: expandA
            title: "EXPAND"
            valueColor: theme.mainBeamColorA
            dmxIndex: 13
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: gradientA
            title: "GRADIENT"
            valueColor: theme.mainBeamColorA
            dmxIndex: 14
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: distortA
            title: "DISTORT"
            valueColor: theme.mainBeamColorA
            dmxIndex: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: filterA
            title: "FILTER"
            valueColor: theme.mainBeamColorA
            dmxIndex: 16
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: switchB
            title: "SW B"
            valueColor: theme.mainBeamColorB
            dmxIndex: 17
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: sizeAndOobB
            title: "SIZE & OOB"
            valueColor: theme.mainBeamColorB
            dmxIndex: 18
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: patternTypeGaugeB
            title: "PATT TYPE"
            valueColor: theme.mainBeamColorB
            dmxIndex: 19
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: patternSelectB
            title: "PATT SEL"
            valueColor: theme.mainBeamColorB
            dmxIndex: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: scaleB
            title: "SCALE"
            valueColor: theme.mainBeamColorB
            dmxIndex: 21
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: orientB
            title: "ORIENT"
            valueColor: theme.mainBeamColorB
            dmxIndex: 22
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: horizShiftB
            title: "SHFT HORIZ"
            valueColor: theme.mainBeamColorB
            dmxIndex: 23
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: vertShiftB
            title: "SHFT VERT"
            valueColor: theme.mainBeamColorB
            dmxIndex: 24
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: horizZoomB
            title: "ZOOM HORIZ"
            valueColor: theme.mainBeamColorB
            dmxIndex: 25
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: vertZoomB
            title: "ZOOM VERT"
            valueColor: theme.mainBeamColorB
            dmxIndex: 26
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: colorShiftB
            title: "CLR SHIFT"
            valueColor: theme.mainBeamColorB
            dmxIndex: 27
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: colorB
            title: "COLOR"
            valueColor: theme.mainBeamColorB
            dmxIndex: 28
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: nodeB
            title: "SCAN"
            valueColor: theme.mainBeamColorB
            dmxIndex: 29
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: expandB
            title: "EXPAND"
            valueColor: theme.mainBeamColorB
            dmxIndex: 30
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: gradientB
            title: "GRADIENT"
            valueColor: theme.mainBeamColorB
            dmxIndex: 31
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: distortB
            title: "DISTORT"
            valueColor: theme.mainBeamColorB
            dmxIndex: 32
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CircularGauge {
            id: filterB
            title: "FILTER"
            valueColor: theme.mainBeamColorB
            dmxIndex: 33
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Component.onCompleted: {
        connectChildItems(page)
    }
}
