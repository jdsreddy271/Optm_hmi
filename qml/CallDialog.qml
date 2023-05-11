import QtQuick 2.2
import QtQuick.Controls 2.2
import "HmiParams.js" as HmiParams

Popup {
    id: popup
    x: 10
    y: 30
    width: 250
    height: 175
    modal: true
    focus: true

    background: Rectangle {
        color: "#B8E5E3"
        border.color: "white"
    }
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    property string callnum: ""
    property string callmsg: ""

    Timer {
        id: popUpTimer
        repeat: false
        interval: 10000
        running: false
        onTriggered: {
            DATAPROVIDER.sendCallResp(2)
            popup.close()
        }
    }

    Connections {
        target: DATAPROVIDER
        onCallEvent: {
            popup.callnum = sNum
            popup.callmsg = sMsg
            popUpTimer.start()
        }
    }

    Text {
        id: callNumber
        x: 25
        y: 100
        text: qsTr(popup.callnum)
        font.pixelSize: 22
        font.family: HmiParams.FONT_RAJ_BOLD
        font.bold: true
        color: HmiParams.COLOUR_BLUE
        smooth: true
        width: implicitWidth
        height: implicitHeight

        anchors{
            top: parent.top
            topMargin: 5
            left:parent.left
            leftMargin:10
        }
    }
    Text {
        id: callMsg
        x: 25
        y: 100
        text: qsTr(popup.callmsg)
        font.pixelSize: 20
        font.family: HmiParams.FONT_RAJ_BOLD
        font.bold: true
        color: HmiParams.COLOUR_BLUE
        smooth: true
        width: implicitWidth
        height: implicitHeight
        anchors{
            top: callNumber.bottom
            topMargin: 10
            left:callNumber.left
            leftMargin:0
        }
    }
    Rectangle{
        id: rejectButton
        x: 239
        y: 215
        width: 80
        height: 80
        opacity: 1
        color: "transparent"
        anchors{
            top: callMsg.bottom
            topMargin: 10
            right:parent.right
            rightMargin:0
        }
        Image {
            id: rejectCallImg
            source: HmiParams.IMG_CALL_DECLINE
            width: (sourceSize.width)*0.75
            height: (sourceSize.height)*0.75
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                popUpTimer.stop()
                DATAPROVIDER.sendCallResp(1)
                popup.close()
            }
        }
    }

    Rectangle{
        id: acceptButton
        x: 37
        y: 215
        width: 80
        height: 80
        opacity: 1
        color: "transparent"
        anchors{
            top: callMsg.bottom
            topMargin: 10
            left:parent.left
            leftMargin:10
        }
        Image {
            id: acceptCallImg
            source: HmiParams.IMG_CALL_ACCEPT
            width: (sourceSize.width)*0.75
            height: (sourceSize.height)*0.75
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                popUpTimer.stop()
                DATAPROVIDER.sendCallResp(0)
                popup.close()
            }
        }
    }
}

