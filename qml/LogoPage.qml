import QtQuick 2.0
import "HmiParams.js" as HmiParams

Item {
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "white"//"#112a52" // "dark blue"

        Image {
            id: logo
            source: HmiParams.IMG_LOGO
            anchors.centerIn: parent
            width: sourceSize.width/2
            height: sourceSize.width/2


        }
//        Text {
//            id: logomsg
//            text: qsTr("www.optmsol.com")
//            font.pixelSize: 30
//            font.family:HmiParams.FONT_RAJ_BOLD
//            font.bold: true
//            color: "white" //"dark blue"
//            smooth: true
//            width: implicitWidth
//            height: implicitHeight
//            anchors.top: logo.bottom
//            anchors.topMargin: 4
//            anchors.horizontalCenter: parent.horizontalCenter
//            opacity: 1
//        }
    }

}
