import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: controlSpace
    property bool isBeamA: true

    signal sigModeChanged(string newMode)

    // Dynamic border color based on beam selection
    border.color: isBeamA ? "red" : "blue"
    border.width: 3
    width: 300
    height: 600

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Header
        RowLayout {
            id: header
            width: parent.width
            height: 50

            // Beam Selector
            ModeSelector {
                id: beamSelector
                modeStrings: [{"display": "Beam A", "internal": "beamA"}, {"display": "Beam B", "internal": "beamB"}]
                layoutDirection: "horizontal"
                activeColor: "lightgrey"
                inactiveColor: "darkgrey"
                spacing: 10
                onSigModeChanged: {
                    controlSpace.isBeamA = (newMode === "beamA")
                }
            }

            // Page Selector
            ModeSelector {
                id: pageSelector
                modeStrings: [{"display": "Pattern", "internal": "pattern"}, {"display": "Scale & Orient", "internal": "scaleAndOrient"}, {"display": "Shift & Twist", "internal": "shiftAndTwist"}, {"display": "Moar Effects", "internal": "moarEffects"}]
                layoutDirection: "horizontal"
                activeColor: Theme.accentColor
                inactiveColor: Theme.baseColor
                spacing: 10
                onSigModeChanged: {
                    controlSpace.sigModeChanged(newMode)
                }
            }
        }

        // Top-level stack for beams
        StackLayout {
            id: beamStack
            anchors.fill: parent

            // Beam A Control Panel
            Rectangle {
                color: "transparent"
                RowLayout {
                    anchors.fill: parent
                    visible: controlSpace.isBeamA
                    StackLayout {
                        id: beamAStack
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        // Pattern Page
                        Rectangle {
                            color: "transparent"
                            Text { text: "Pattern Page A" }
                        }

                        // Scale & Orient Page
                        Rectangle {
                            color: "transparent"
                            Text { text: "Scale & Orient Page A" }
                        }

                        // Shift & Twist Page
                        Rectangle {
                            color: "transparent"
                            Text { text: "Shift & Twist Page A" }
                        }

                        // Moar Effects Page
                        Rectangle {
                            color: "transparent"
                            Text { text: "Moar Effects Page A" }
                        }
                    }
                }
            }

            // Beam B Control Panel
            Rectangle {
                color: "transparent"
                RowLayout {
                    anchors.fill: parent
                    visible: !controlSpace.isBeamA
                    StackLayout {
                        id: beamBStack
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        // Pattern Page
                        Rectangle {
                            color: "transparent"
                            Text { text: "Pattern Page B" }
                        }

                        // Scale & Orient Page
                        Rectangle {
                            color: "transparent"
                            Text { text: "Scale & Orient Page B" }
                        }

                        // Shift & Twist Page
                        Rectangle {
                            color: "transparent"
                            Text { text: "Shift & Twist Page B" }
                        }

                        // Moar Effects Page
                        Rectangle {
                            color: "transparent"
                            Text { text: "Moar Effects Page B" }
                        }
                    }
                }
            }
        }
    }
}
