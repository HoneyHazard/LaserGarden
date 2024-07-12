import QtQuick 2.15

QtObject {
    // General colors
    property color primaryBackgroundColor: "#1b1e23"  // Dark background
    property color secondaryBackgroundColor: "#2b2e33"  // Slightly lighter dark background
    property color tertiaryBackgroundColor: "#3b3e43"  // Even lighter dark background

    // Element colors
    //property color activeElement: "#f8d210"  // Bright yellow for active elements
    //property color inactiveElement: "#7c7f84"  // Grey for inactive elements
    //property color clickedElement: "#10f8d2"  // Bright cyan for clicked elements
    //property color heldElement: "#d210f8"  // Bright magenta for held elements

    property color activeElementColor: "cyan"  // Bright yellow for active elements
    property color inactiveElementColor: "gray"  // Grey for inactive elements
    property color clickedElementColor: "cyan"  // Bright cyan for clicked elements
    property color heldElementColor: "magenta"  // Bright magenta for held elements

    property color defaultGaugeColor: "lime"  // Off-white for primary elements

    // Borders
    property real borderWidth: 2
    property color primaryBorderColor: "#f8f8f2"  // Off-white border
    property color secondaryBorderColor: "#c0c0c0"  // Light grey border

    // Text
    //property color primaryTextColor: "#f8f8f2"  // Off-white text
    property color primaryTextColor: "white"  // Off-white text
    property color secondaryTextColor: "#c0c0c0"  // Light grey text
    property string primaryFont: "Courier New"
    property int primaryFontSize: 14
    property int secondaryFontSize: 12
}
