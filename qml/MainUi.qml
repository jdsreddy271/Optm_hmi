import QtQuick 2.2
import "HmiParams.js" as HmiParams

Item {
    property int rootItemWidth:HmiParams.SCREEN_WIDTH
    property int rootItemHeight:HmiParams.SCREEN_HEIGHT
    property double dimensionRatio: 1

    focus: true
    property int colorMode: HmiParams.SCREEN_MODE_WHITE
    property int batteryValue: 0
    property int speed: 0
    property int speed_angle: 0
    property int back: 0
    property int middle: 10
    property int front: 20
    property alias dtebase: dtebase
    property int screenType: HmiParams.SCREEN_MAIN
    property int mapDir: 0
    property int mapDist: 0
    property int speedoOffset: 0

    signal showSettingPage()
    NumberAnimation on speed{ id:speed_anim;}
    NumberAnimation on speed_angle{ id:angle_anim;}
    NumberAnimation on speedoOffset{ id:offset_anim;}

    Component.onCompleted: {
        dimensionRatio = rootItemWidth/rootItemHeight
    }

    onWidthChanged: {
        recalculateDimension()
    }

    onHeightChanged: {
        recalculateDimension()
    }

    function recalculateDimension() {

    }

    Image {
        id: bg
        source: colorMode == 0 ? HmiParams.IMG_BG_WHITE : (colorMode == 1 ? HmiParams.IMG_BG_BLUE : HmiParams.IMG_BG_RED)
        x: ((parent.width/rootItemWidth)*0)
        y: ((parent.height/rootItemHeight)*0)
        opacity: 1
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
        z: middle
    }
    Image {
        id: blend
        source: HmiParams.IMG_BLEND
        x: ((parent.width/rootItemWidth)*183)+speedoOffset
        y: ((parent.height/rootItemHeight)*50)
        opacity: 0.75
        width: ((parent.width/rootItemWidth)*sourceSize.width)*0.95
        height: ((parent.height/rootItemHeight)*sourceSize.height)*0.95
        z: middle
    }

    
    ProgressCircle {
        id: pb
        anchors.centerIn: speedodial
        width: speedodial.width*0.96
        height: width
        size: speedodial.width*0.96
        colorCircle: speed > 70 ? HmiParams.COLOUR_RED : HmiParams.COLOUR_GREEN
        showBackground: false
        lineWidth: 8
        arcOffset: -126.5
        value: speed_angle
        z: middle
    }
    
    Image {
        id: speedodial
        source: HmiParams.IMG_SPEEDO
        x: ((parent.width/rootItemWidth)*195)+ speedoOffset
        y: ((parent.height/rootItemHeight)*55)
        z: middle
        opacity: 1
        smooth: true
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
    }
    Image {
        id: needle
        source: HmiParams.IMG_NEEDLE
        x: (parent.width/2 - width)+ speedoOffset
        y: speedodial.y + speedodial.height/2
        z: middle
        opacity: 1
        smooth: true
        width: ((parent.width/rootItemWidth)*sourceSize.width*0.95)
        height: ((parent.height/rootItemHeight)*sourceSize.height*0.95)
        transform: Rotation { origin.x: needle.width; origin.y: 0; angle: speed_angle+9}
    }
    Image {
        id: digcircle
        source: HmiParams.IMG_DIG_CIRCLE
        anchors.centerIn: speedodial
        z: middle+2
        opacity: 1
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
        Text {
            id: kmphVale
            text: speed
            font.pixelSize: 55
            font.family: HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: speed > 70 ? HmiParams.COLOUR_RED  : HmiParams.COLOUR_WHITE
            smooth: true
            width: implicitWidth
            height: implicitHeight
            anchors.centerIn: parent
            x: ((parent.width/rootItemWidth)*366)
            y: ((parent.height/rootItemHeight)*238)
            opacity: 1
        }
        Text {
            id: kmph
            text: qsTr("kmph")
            font.pixelSize: 15
            font.family:HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: HmiParams.COLOUR_WHITE
            smooth: true
            width: implicitWidth
            height: implicitHeight
            anchors.top: kmphVale.bottom
            anchors.topMargin: 4
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.8
        }
    }

    Image {
        id: odobase
        source: colorMode == 0 ? HmiParams.IMG_ODOBASE : HmiParams.IMG_ODOBASE_BLUE
        x: ((parent.width/rootItemWidth)*320) +speedoOffset// (screenType == 1 ? 100: 0)
        y: ((parent.height/rootItemHeight)*400)
        z: middle
        opacity: 1
        smooth: true
        width: ((parent.width/rootItemWidth)*sourceSize.width)+25
        height: ((parent.height/rootItemHeight)*sourceSize.height)


        Text {
            id: odopmsg
            text: qsTr("Odo (km)")
            font.pixelSize: 25
            font.family: HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: HmiParams.COLOUR_WHITE
            smooth: true
            anchors.left: odobase.left
            anchors.leftMargin: 15
            anchors.top: odobase.bottom
            z: front
            opacity: 0.8
        }

        Text {
            id: odoval
            text: qsTr("0")
            font.pixelSize: 40
            font.family: HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: HmiParams.COLOUR_WHITE
            smooth: true
            anchors.right: odobase.right
            anchors.rightMargin: 25
            anchors.bottom: odobase.top
            z: front
            opacity: 1
        }
    }

    Image {
        id: iconmap
        source: HmiParams.IMG_MAP_WHITE
        x: ((parent.width/rootItemWidth)*20)
        y: ((parent.height/rootItemHeight)*100)
        anchors.left: parent.left
        anchors.leftMargin: 20
        z: middle
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
        opacity: 1
    }
    Image {
        id: settings
        source: HmiParams.IMG_SETTING
        x: ((parent.width/rootItemWidth)*20)
        y: ((parent.height/rootItemHeight)*200)
        anchors.left: parent.left
        anchors.leftMargin: 20
        z: middle
        opacity: 1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                showSettingPage();
            }
        }
    }


    Image {
        id: right_dir
        source: HmiParams.IMG_IND_RIGHT
        anchors.fill: rightarrow
        z: front
        opacity: 1
        visible: false
    }

    Image {
        id: left_dir
        source: HmiParams.IMG_IND_LEFT
        anchors.fill: leftarrow
        z: front
        opacity: 1
        visible: false
    }

    Text {
        id: eco_mode
        text: qsTr("Eco Mode")
        font.pixelSize: 20
        font.family: "Poppins-MediumItalic"
        font.italic: true
        color: colorMode == 0 ? HmiParams.FONT_THEME_LIGHT:HmiParams.FONT_THEME_DARK
        smooth: true
        x: ((parent.width/rootItemWidth)*280)
        y: ((parent.height/rootItemHeight)*15)
        z: front
        opacity: 1
        width: implicitWidth
        height: implicitHeight
    }
//    Text {
//        id: am
//        text: qsTr("7:52AM")
//        font.pixelSize: 14
//        font.family: "Poppins-Medium"
//        color: HmiParams.COLOUR_WHITE
//        smooth: true
//        x: ((parent.width/rootItemWidth)*12)
//        y: ((parent.height/rootItemHeight)*17)
//        opacity: 1
//        width: implicitWidth
//        height: implicitHeight
//        z: middle
//    }

    Image {
        id: logo_main
        source:HmiParams.IMG_LOGO1X
        x: ((parent.width/rootItemWidth)*10)
        y: ((parent.height/rootItemHeight)*5)
        opacity: 1
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
        z: middle
    }

    Image {
        id: iconBle
        //source:colorMode == 0 ? HmiParams.IMG_BLE_BLACK:HmiParams.IMG_BLE_WHITE
        source:HmiParams.IMG_BLE_WHITE
        x: ((parent.width/rootItemWidth)*100)
        y: ((parent.height/rootItemHeight)*7)
        opacity: 1
        width: ((parent.width/rootItemWidth)*sourceSize.width)*2
        height: ((parent.height/rootItemHeight)*sourceSize.height)*2
        z: middle
    }
//    Image {
//        id: icon4G
//        //source: colorMode == 0 ? HmiParams.IMG_4G_BLACK :HmiParams.IMG_4G_WHITE
//        source :HmiParams.IMG_4G_WHITE
//        x: ((parent.width/rootItemWidth)*60)
//        y: ((parent.height/rootItemHeight)*13)
//        opacity: 1
//        width: ((parent.width/rootItemWidth)*sourceSize.width) *2
//        height: ((parent.height/rootItemHeight)*sourceSize.height) *2
//        z: middle
//    }

    Rectangle {
        id: battery
        width: 60
        height: 350
        anchors.right :parent.right
        anchors.rightMargin :15
        anchors.top :parent.top
        anchors.topMargin :90
        x: ((parent.width/rootItemWidth)*730)
        y: ((parent.height/rootItemHeight)*80)
        z: back
    }

    Rectangle {
        anchors.fill: battery
        color: colorMode == 0 ? "white" : (colorMode == 1 ? "#000E29" : "#290000")
        z: front
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: (parent.height*(batteryValue+ 4)/100)
            color: fuelVale.color
        }
    }
    Text {
        id: fuelVale
        text: batteryValue
        font.pixelSize: 40
        font.family: HmiParams.FONT_RAJ_BOLD
        font.bold: true
        color: batteryValue >= 25 ?HmiParams.COLOUR_GREEN : HmiParams.COLOUR_RED
        smooth: true
        anchors.right: fuelpers.left
        anchors.rightMargin: 2
        x: ((parent.width/rootItemWidth)*715)
        y: ((parent.height/rootItemHeight)*25)
        z: front
        opacity: 1
    }
    Text {
        id: fuelpers
        text: "%"
        font.pixelSize: 20
        font.family: HmiParams.FONT_RAJ_BOLD
        font.bold: true
        color: batteryValue >= 25 ?HmiParams.COLOUR_GREEN : HmiParams.COLOUR_RED
        smooth: true
        anchors.right: parent.right
        anchors.rightMargin: 10
        x: ((parent.width/rootItemWidth)*715)
        y: ((parent.height/rootItemHeight)*40)
        z: front
        opacity: 1
    }
    Image {
        id: dtebase
        source: colorMode == 0 ? HmiParams.IMG_DTEBASE_BLUE : HmiParams.IMG_DTEBASE        
        x: ((parent.width/rootItemWidth)*0)
        y: ((parent.height/rootItemHeight)*450)
        opacity: 0.8
        width: ((parent.width/rootItemWidth)*sourceSize.width)-20
        height: ((parent.height/rootItemHeight)*sourceSize.height)
        z:front

        Text {
            id: dtemsg
            text: qsTr("DTE (km)")
            font.pixelSize: 20
            font.family: HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: colorMode == 0 ? HmiParams.FONT_THEME_LIGHT:HmiParams.FONT_THEME_DARK
            smooth: true
            anchors.left: dtebase.left
            anchors.leftMargin: 2
            anchors.top: dtebase.bottom
            z: front
            opacity: 0.9
        }

        Text {
            id: dteval
            text: qsTr("0")
            font.pixelSize: 40
            font.family: HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: colorMode == 0 ? HmiParams.FONT_THEME_LIGHT:HmiParams.FONT_THEME_DARK
            smooth: true
            anchors.right: dtebase.right
            anchors.rightMargin: 5
            anchors.bottom: dtebase.top
            z: front
            opacity: 1
        }
    }

    Image {
        id: tripBase
        source: colorMode == 0 ? HmiParams.IMG_TRIPBASE_BLUE : HmiParams.IMG_TRIPBASE
        x: ((parent.width/rootItemWidth)*0)+ (screenType == 1 ? 150: 0)
        y: ((parent.height/rootItemHeight)*350) +(screenType == 1 ? 100: 0)
        opacity: 0.8
        width: ((parent.width/rootItemWidth)*sourceSize.width) -20
        height: ((parent.height/rootItemHeight)*sourceSize.height)
        z: front

        Text {
            id: tripmsg
            text: qsTr("Trip (km)")
            font.pixelSize: 20
            font.family: HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: colorMode == 0 ? HmiParams.FONT_THEME_LIGHT:HmiParams.FONT_THEME_DARK
            smooth: true
            anchors.left: tripBase.left
            anchors.leftMargin:2
            anchors.top: tripBase.bottom
            z: front
            opacity: 0.9
        }

        Text {
            id: tripval
            text: qsTr("0")
            font.pixelSize: 40
            font.family: HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: colorMode == 0 ? HmiParams.FONT_THEME_LIGHT:HmiParams.FONT_THEME_DARK
            smooth: true
            anchors.right: tripBase.right
            anchors.rightMargin: 5
            anchors.bottom: tripBase.top
            z: front
            opacity: 1
        }
    }

    Image {
        id: leftarrow
        source:HmiParams.IMG_LEFTARROW
        x: ((parent.width/rootItemWidth)*125)
        y: ((parent.height/rootItemHeight)*20)
        opacity: 0
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
        z: front
    }

    Image {
        id: rightarrow
        source: HmiParams.IMG_RIGHTARROW
        x: ((parent.width/rootItemWidth)*640)
        y: ((parent.height/rootItemHeight)*20)
        opacity: 0
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
        z: front
    }

    Image {
        id: routedir
        source: HmiParams.IMG_LOCATION
        x: ((parent.width/rootItemWidth)*100)
        y: ((parent.height/rootItemHeight)*90)
        opacity: 1
        visible: false
        width: ((parent.width/rootItemWidth)*sourceSize.width)
        height: ((parent.height/rootItemHeight)*sourceSize.height)
        z: front

        Text {
            id: distmsg
            text: qsTr("0 mts")
            font.pixelSize: 25
            font.family: HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: colorMode == 0 ? HmiParams.FONT_THEME_LIGHT:HmiParams.FONT_THEME_DARK
            smooth: true
            anchors.top: routedir.bottom
            anchors.topMargin: 15
            anchors.left: routedir.left
            anchors.leftMargin: 30
            visible:false
            z: front
            opacity: 1
        }
    }
    Rectangle {
        id: dirInfo
        width: 220
        height: 95
        //border.color: HmiParams.COLOUR_RED
        anchors.left :parent.left
        anchors.leftMargin :60
        anchors.top :parent.top
        anchors.topMargin :305
        color: "transparent"
        z: front
        visible:false

        Text {
            id: routemsg
            anchors.fill:parent
            text: qsTr("")
            font.pixelSize: 25
            font.family: HmiParams.FONT_RAJ_BOLD
            font.bold: true
            color: colorMode == 0 ? HmiParams.FONT_THEME_LIGHT:HmiParams.FONT_THEME_DARK
            smooth: true
            wrapMode: Text.Wrap
            anchors.alignWhenCentered: true
            visible:false
            opacity: 1
        }
    }
    // Here we will receive signal/data whenever change in mode or speed from c++(hmidatahandler)
    Connections {
        target: DATAPROVIDER

        onModeChanged: {
            eco_mode.text = mode;
            eco_mode.color = isError ? HmiParams.COLOUR_RED : "white"
        }

        onSpeedChanged: {
            speed_anim.duration = ((Math.abs(speed - mspeed)*1000)/HmiParams.SCREEN_FREAMERATE);
            angle_anim.duration = speed_anim.duration; //5000
            speed_anim.to = mspeed;
            angle_anim.to = dangle;
            speed_anim.stop();
            angle_anim.stop();
            speed_anim.start();
            angle_anim.start();
            console.log("speed = ",speed_anim.to);
            console.log("Angle = ",angle_anim.to);
            console.log("speed_anim.duration = ",speed_anim.duration);
        }


        onBatteryChanged: {
            batteryValue = mbattery
        }

        onColorChanged: {
            colorMode = cmode
           // pb.colorCircle = colorMode != 1 ? HmiParams.COLOUR_RED : "#072ACC"
              pb.colorCircle = speed >70 ? HmiParams.COLOUR_RED : HmiParams.COLOUR_GREEN //"#072ACC"
        }

        onDistanceChanged: {
            odoval.text = dist
        }

        onShowLeftChanged: {
            left_dir.visible = show
        }

        onShowRightChanged: {
            right_dir.visible = show
        }

        onDteChanged: {
            dteval.text = mdte
        }

        onTripValueChanged: {
            tripval.text = mtrip
        }

        onScreenChanged: {
            screenType = mscreen
            speedoOffset = screenType == 1 ? 100: 0
        }

        onBleStatusChanged: {
            console.log("onBleStatusChanged")
            iconBle.visible = false
            if(mstatus == 1)
            {
                //source:colorMode == 0 ? HmiParams.IMG_BLE_BLACK:HmiParams.IMG_BLE_WHITE
                iconBle.source = HmiParams.IMG_BLE_BLACK
            }
            else
            {
                iconBle.source = HmiParams.IMG_BLE_WHITE
            }
            iconBle.visible = true
        }

        onNavChanged: {
            routedir.visible = false
            routemsg.visible = false
            distmsg.visible  = false
            dirInfo.visible  = false

            mapDist = mdist/10
            mapDir = mdir

            if(mapDist >= 1000)
            {
                distmsg.text = (mapDist/1000)+ " km"
            }
            else
            {
                distmsg.text =   mapDist + " mts"
            }
            routemsg.text =smsg
            console.log("onNavChanged : ",mapDist,": ",mapDir)
            switch (mdir)   {
                case 0:
                    routedir.source = HmiParams.IMG_LOCATION  // start location
                break;
                case 1:
                    routedir.source = HmiParams.IMG_DIR_LEFT_UTURN //uturn
                break;
                case 2:
                    routedir.source = HmiParams.IMG_DIR_RIGHT_SHARP //sharp right
                break;
                case 3:
                    routedir.source = HmiParams.IMG_DIR_RIGHT
                break;
                case 4:
                    routedir.source = HmiParams.IMG_DIR_RIGHT_SELECT   //slight right
                break;
                case 5:
                    routedir.source = HmiParams.IMG_DIR_RIGHT_UTURN
                break;
                case 6:
                    routedir.source = HmiParams.IMG_DIR_LEFT_SELECT   // slight left
                break;
                case 7:
                    routedir.source = HmiParams.IMG_DIR_LEFT   //  left
                break;
                case 8:
                    routedir.source = HmiParams.IMG_DIR_LEFT_SHARP   // Sharp left
                break;
                default:
                    routedir.source = HmiParams.IMG_DIR_STRIGHT
                break;

            }
            if(screenType ==1){
                routedir.visible = true
                routemsg.visible = true
                distmsg.visible  = true
                dirInfo.visible  = true
            }
        }
    }

    Rectangle {
        anchors.centerIn: iconmap
        width: iconmap.width*2.5
        height: iconmap.height*2.5
//        border.color: HmiParams.COLOUR_RED
        color: "Transparent"
        z: front


       MouseArea{
            anchors.fill: parent
            onClicked: {
              console.log("on clicked")
                if(screenType == 0)
                {
                   screenType = 1;
                }
                else
                {
                    screenType = 0;
                      }

                if(screenType ==1)
                {
                    speedoOffset = 100
                    routedir.visible = true
                    routemsg.visible = true
                    distmsg.visible  = true
                    dirInfo.visible  = true
                    iconmap.source= HmiParams.IMG_MAPCLOSE
                }
                else
                {

                    speedoOffset = 0;
                    routedir.visible = false
                    routemsg.visible = false
                    distmsg.visible  = false
                    dirInfo.visible  = false
                    iconmap.source= HmiParams.IMG_MAP_WHITE
                }

           }

        }
   }
}
