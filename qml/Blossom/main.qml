import QtQuick 2.0

Rectangle {


    width: 360
    height: 360
    property int cell_size: 48


    Grid {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        rows: parent.height/parent.cell_size
        columns: parent.width/parent.cell_size
        spacing: 0
        objectName: "flowerGrid"
        id: flowerGrid
        signal grabbed(var openedFlowers, var closedFlowers);

        Connections {
            target: flowerHandler
            onUpdateGrid: {
                flowerGrid.grabbed(openedFlowers, closedFlowers)
            }
          }

        onGrabbed: {
//            for(var j = 0; j < closedFlowers.length; j+=2){
//                flowerRepeater.itemAt(flowerGrid.columns*closedFlowers[j] + closedFlowers[j+1]*1).close();
//            }

            for(var j = 0; j < openedFlowers.length; j+=2){
                flowerRepeater.itemAt(flowerGrid.columns*openedFlowers[j] + openedFlowers[j+1]*1).open();
            }
        }

        Repeater {
            function mdlChanged() {
                // We trigger a signal here to change the grabbing
                if(ready){
                    flowerHandler.gridCompleted(parent.rows, parent.columns);
                }
            }

            function completed() {
                ready = true;
            }

            model: parent.rows * parent.columns
            objectName: "flowerRepeater"
            id: flowerRepeater
            property bool ready: false

            onModelChanged: mdlChanged();
            Component.onCompleted: completed();

            delegate: Flower{
                column: x/(cell_size-1)
                row: y/(cell_size-1)
                objectName: "flower"
            }
        }

    }
}
