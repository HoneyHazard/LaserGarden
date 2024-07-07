import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: page

    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: 10

        CircularGauge {
            id: gauge1
            dmxIndex: 0
            value: dmxArray.get_value(0)
            onValueUpdated: handleValueUpdated
        }

        CircularGauge {
            id: gauge2
            dmxIndex: 1
            value: dmxArray.get_value(1)
            onValueUpdated: handleValueUpdated
        }

        CircularGauge {
            id: gauge3
            dmxIndex: 2
            value: dmxArray.get_value(2)
            onValueUpdated: handleValueUpdated
        }

        CircularGauge {
            id: gauge4
            dmxIndex: 3
            value: dmxArray.get_value(3)
            onValueUpdated: handleValueUpdated
        }

        CircularGauge {
            id: gauge5
            dmxIndex: 4
            value: dmxArray.get_value(4)
            onValueUpdated: handleValueUpdated
        }

        CircularGauge {
            id: gauge6
            dmxIndex: 5
            value: dmxArray.get_value(5)
            onValueUpdated: handleValueUpdated
        }
    }

    function handleValueUpdated(dmxIndex, value) {
        dmxArray.set_value(dmxIndex, value)
    }
}
