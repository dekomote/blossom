import QtQuick 2.0

Rectangle {
    width: 32
    height: 32
    id: outer_wrapper
    property int row: 0
    property int column: 0
    property string new_st1;
    property string new_st2;
    property string new_st3;
    property var st1_all: ['images/1_1.png', 'images/1_2.png', 'images/1_3.png', 'images/1_4.png' ,'images/1_5.png']
    property var st2_all: ['images/2_1.png', 'images/2_2.png', 'images/2_3.png', 'images/2_4.png' ,'images/2_5.png']
    property var st3_all: ['images/3_1.png', 'images/3_2.png', 'images/3_3.png', 'images/3_4.png' ,'images/3_5.png']

    signal open()
    signal close()
    signal changeBg()

    onOpen: {
        bg.open();
        //closeTimer.start();
    }

    onClose: {
        bg.close()
    }

    onChangeBg: {
        bg.st1 = new_st1;
        bg.st2 = new_st2;
        bg.st3 = new_st3;
    }

    Image {
        width: parent.width
        height: parent.height
        id: bg
        property string st1: 'images/1_1.png'
        property string st2: 'images/2_2.png'
        property string st3: 'images/3_5.png'
        property string st_end: bg.st3
        source: st1

        Timer {
            id: closeTimer;
            interval: 1000;
            running: false;
            repeat: false;
            onTriggered: parent.close();
        }

        MouseArea {
              id: mouseArea
              anchors.fill: parent
              //onHoveredChanged: console.log(parent.parent.row, parent.parent.column, parent.parent.x)
              hoverEnabled: true
          }

        function open() {
            //if(st_end == bg.st3) {
                //openBlossom.start()
            bg.source = bg.st3;
                //st_end = bg.st1
            //}
        }

        function close() {
            //if(st_end == bg.st1) {
                //closeBlossom.start()
            bg.source=bg.st1;
                //st_end = bg.st3
            //}
        }

        SequentialAnimation {
            id: openBlossom
            PropertyAnimation { target: bg; duration: 50; property: "opacity"; to: 0.5}
            PropertyAnimation { target: bg; duration: 20; property: "source"; to: bg.st2}
            PropertyAnimation { target: bg; duration: 20; property: "source"; to: bg.st3}
            PropertyAnimation { target: bg; duration: 50; property: "opacity"; to: 1}
        }

        SequentialAnimation {
            id: closeBlossom
            PropertyAnimation { target: bg; duration: 50; property: "opacity"; to: 0.5}
            PropertyAnimation { target: bg; duration: 20; property: "source"; to: bg.st2}
            PropertyAnimation { target: bg; duration: 20; property: "source"; to: bg.st1}
            PropertyAnimation { target: bg; duration: 50; property: "opacity"; to: 1}
        }



    }



}
