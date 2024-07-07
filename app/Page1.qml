import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: page

    // signal sigUiChannelChanged(int dmxIndex, int newValue)

    // signal sigDmxChannelChanged(int dmxIndex, int newValue)

    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: 10

        CircularGauge {
            id: gauge1
            dmxIndex: 0
            value: dmxArray.get_value(0)
        }

        CircularGauge {
            id: gauge2
            dmxIndex: 1
            value: dmxArray.get_value(1)
        }

        CircularGauge {
            id: gauge3
            dmxIndex: 2
            value: dmxArray.get_value(2)
        }

        CircularGauge {
            id: gauge4
            dmxIndex: 3
            value: dmxArray.get_value(3)
        }

        CircularGauge {
            id: gauge5
            dmxIndex: 4
            value: dmxArray.get_value(4)
        }

        CircularGauge {
            id: gauge6
            dmxIndex: 5
            value: dmxArray.get_value(5)
        }
    }

/*
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
                console.log("Setting up DMX channel handler for: " + childItem.dmxIndex)
                page.sigDmxChannelChanged.connect(childItem.onDmxChannelChanged)
            }
            if (childItem.sigUiChannelChanged) {
                console.log("Setting up UI channel handler for: " + childItem.dmxIndex)
                childItem.sigUiChannelChanged.connect(page.sigUiChannelChanged)
            }

            // Recursively iterate through the child's children
            if (childItem.children && childItem.children.length > 0) {
                connectChildItems(childItem)
            }
        }
    }
    

    Component.onCompleted: {
        connectChildItems(page)
    }
*/

    /*
    function handleValueUpdated(dmxIndex, value) {
        dmxArray.set_value(dmxIndex, value)
    }
    */
}
