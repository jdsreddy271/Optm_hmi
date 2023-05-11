import QtQuick 2.0
//import QtGraphicalEffects 1.0
//import QtQuick.Controls 2.0
import "HmiParams.js" as HmiParams

Item {

    anchors.fill: parent
    visible: false
    property int colorMode: 0
    property int speedOnMap: 0
    property int rootItemWidth:HmiParams.SCREEN_WIDTH
    property int rootItemHeight:HmiParams.SCREEN_HEIGHT
    property double dimensionRatio: 1
    property int back: 0
    property int middle: 5
    property int front: 20

    signal minimizeClicked()
    signal closeClicked()

    Connections {
        target: DATAPROVIDER

        onSpeedChanged: {
            speedOnMap = mspeed
        }
    }

    Rectangle {
        anchors.fill: parent
        color: colorMode == 0 ? "white" : "black"

        // title
        Text {
            id: themeTitle
            width: implicitWidth
            height: implicitHeight
            text: "Theme"
            font.pixelSize: 20
            font.bold: true
            color: colorMode == 0 ? "black" : "white"
            anchors.horizontalCenter: parent.horizontalCenter
            font.underline: true
        }

        Rectangle {
            id: lightModeButton
            width: 100
            height: 40
            color: "orange"
            anchors.top: themeTitle.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 300
            border.color: "orange"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    colorMode = 0;
                }
            }
            Text {
                id: lightModeTitle
                width: implicitWidth
                height: implicitHeight
                text: "Light"
                font.pixelSize: 20
                font.bold: true
                color: "black"
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: darkModeButton
            width: 100
            height: 40
            color: "orange"
            anchors.top: themeTitle.bottom
            anchors.topMargin: 10
            anchors.left: lightModeButton.right
            anchors.leftMargin: 15
            border.color: "orange"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    colorMode = 1;
                }
            }
            Text {
                id: darkModeTitle
                width: implicitWidth
                height: implicitHeight
                text: "Dark"
                font.pixelSize: 20
                font.bold: true
                color: "black"
                anchors.centerIn: parent
            }
        }
    }

//    Image {
//        id: bg
//        source: colorMode == 0 ? HmiParams.IMG_BG_WHITE: (colorMode == 1 ? HmiParams.IMG_BG_BLUE : HmiParams.IMG_BG_RED)
//        x: ((parent.width/rootItemWidth)*0)
//        y: ((parent.height/rootItemHeight)*0)
//        opacity: 1
//        width: ((parent.width/rootItemWidth)*sourceSize.width)
//        height: ((parent.height/rootItemHeight)*sourceSize.height)
//        z: back
//    }

//    Text {
//        id: brightnessTitleItem
//        text: "Display Brightness"
//        font.pixelSize: 22
//        font.family: HmiParams.FONT_RAJ_BOLD
//        font.bold: true
//        color:HmiParams.SETTINGS_BRIGHTNESS_TITLE_FONT_COLOR_LIGHT
//        smooth: true
//        x: ((parent.width/rootItemWidth)*200)
//        y: ((parent.height/rootItemHeight)*100)
//        z: front
//        opacity: 1
//    }


//    Slider {
//        id: control
//        anchors{
//            top: brightnessTitleItem.bottom
//            topMargin: 5
//            left: brightnessTitleItem.left
//            leftMargin: 10
//        }
//        focus:true

//        from: 1
//        to: 100
//        value: 50

//        background: Rectangle {
//            x: control.leftPadding
//            y: control.topPadding + control.availableHeight/2  - height / 2
//            z: front
//            implicitWidth: 465
//            implicitHeight: 13.72
//            width: control.availableWidth
//            height: implicitHeight
//          //  color:(currentModeOption == 0) ? HmiParams.SETTINGS_BRIGHTNESS_BAR_COLOR_LIGHT : HmiParams.SETTINGS_BRIGHTNESS_BAR_COLOR_DARK
//            color:HmiParams.SETTINGS_BRIGHTNESS_BAR_COLOR_LIGHT
//            border.width: control.activeFocus ? 1 : 0;
//            border.color: "red";

//            Rectangle {
//                width: control.visualPosition * parent.width
//                height: 5
//                y:4.36
//                gradient: Gradient {
//                    GradientStop { position: 1.0; color: HmiParams.SETTINGS_BLUE_GRADIENT_COLOR_1 }
//                    GradientStop { position: 0.0; color: HmiParams.SETTINGS_BLUE_GRADIENT_COLOR_0 }
//                }
//            }
//        }

//        handle: Rectangle {
//            x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
//            y: control.topPadding + control.availableHeight / 2 - height / 2
//            implicitWidth: 3
//            implicitHeight: 25
//            gradient: Gradient {
//                GradientStop { position: 1.0; color: HmiParams.SETTINGS_BLUE_GRADIENT_COLOR_1 }
//                GradientStop { position: 0.0; color: HmiParams.SETTINGS_BLUE_GRADIENT_COLOR_0 }
//            }
//        }

//        onValueChanged:
//        {
//            DATAPROVIDER.setBrightnessValue(control.value);
//        }
//    }

//    Item{
//        id:modesTitleItem
//        width:63
//        height:30
//        anchors{
//            top:parent.top
//            topMargin:139 - 35
//            left:parent.left
//        }
//        Text {
//            id: modesTitle
//            text: qsTr("Theme")
//            font.pixelSize: 22
//            font.family: HmiParams.FONT_RAJ_BOLD
//            font.bold: true
//            color:HmiParams.SETTINGS_BRIGHTNESS_TITLE_FONT_COLOR_LIGHT
//            smooth: true
//            x: ((parent.width/rootItemWidth)*200)
//            y: ((parent.height/rootItemHeight)*250)
//            z: front
//            opacity: 1
//        }
//    }

//    ListView{
//        id:modeOptionsList
//        height: 48
//        width: 325
//        anchors{
//            top: modesTitleItem.bottom
//            topMargin: 8
//            left:parent.left
//        }
//        model:[("Light"), ("Dark")]
//        orientation: ListView.Horizontal
//        spacing: 22
//        currentIndex: 0
//        focus: true


//         }

}
