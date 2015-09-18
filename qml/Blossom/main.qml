import QtQuick 2.0

Rectangle {


    width: 360
    height: 360
    property int cell_size: 32


    Grid {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        rows: parent.height/parent.cell_size
        columns: parent.width/parent.cell_size
        spacing: 0
        objectName: "flowerGrid"
        id: flowerGrid;
        property bool mutex: false;
        property var flowersToOpen: [];
        property var previousFlowers: [];
        signal grabbed(var openedFlowers, var closedFlowers);

        Connections {
            target: flowerHandler
            onUpdateGrid: {
                flowerGrid.grabbed(openedFlowers, closedFlowers)
            }
          }

        Timer {
            id: transitTimer;
            interval: 10000;
            running: true;
            repeat: true;
            onTriggered: {
                var now = new Date().getTime();
                //parent.st1 = parent.st1_all[(now/10) % 5];

                for(var j = 0; j < (parent.rows * parent.columns); j++){
                    flowerRepeater.itemAt(j).new_st1 = flowerRepeater.itemAt(j).st1_all[now % 5]
                    flowerRepeater.itemAt(j).new_st2 = flowerRepeater.itemAt(j).st2_all[now % 5]
                    flowerRepeater.itemAt(j).new_st3 = flowerRepeater.itemAt(j).st3_all[now % 5]
                    flowerRepeater.itemAt(j).changeBg()
                }

            }
        }

        onGrabbed: {
            if(!flowerGrid.mutex){
                flowerGrid.mutex = true
                for(var j = 0; j < openedFlowers.length; j+=2){
                    flowersToOpen.push(flowerGrid.columns*openedFlowers[j] + openedFlowers[j+1]*1)
                    //previousFlowers.push([flowerGrid.columns*openedFlowers[j], openedFlowers[j+1]*1]);
                }

                previousFlowers.forEach(function(element, index, array){
                    if(flowersToOpen.indexOf(element) < 0) {
                        flowerRepeater.itemAt(element).close();
                    }
                })
                previousFlowers = [];

                flowersToOpen.forEach(function(element, index, array) {
                    flowerRepeater.itemAt(element).open();
                    previousFlowers.push(element);
                });

                flowersToOpen = [];
                flowerGrid.mutex = false;
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
