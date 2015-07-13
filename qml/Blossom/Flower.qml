import QtQuick 2.0

Rectangle {
    width: 32
    height: 32
    id: outer_wrapper
    property int row: 0
    property int column: 0

    signal open()
    signal close()

    onOpen: {
        bg.open();
        closeTimer.start();
    }

    onClose: {
        bg.close()
    }

    Image {
        width: parent.width
        height: parent.height
        id: bg
        property string st1: 'images/1.png'
        property string st2: 'images/2.png'
        property string st3: 'images/3.png'
        property string st_end: bg.st3
        source: st1

        Timer {
            id: closeTimer;
            interval: 500;
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
            if(st_end == bg.st3) {
                openBlossom.start()
                st_end = bg.st1
            }
        }

        function close() {
            if(st_end == bg.st1) {
                closeBlossom.start()
                st_end = bg.st3
            }
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
