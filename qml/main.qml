import QtQuick 2.0
import QtQuick.Window 2.0

import "HmiParams.js" as HmiParams

Window {
    visible: true
    title: qsTr("EV Cluster")

    width: HmiParams.SCREEN_WIDTH
    height: HmiParams.SCREEN_HEIGHT

    Component.onCompleted: {
        timer.start()
    }

    Timer {
        id: timer
        interval: HmiParams.LOGO_DELAY;
        repeat: false
        onTriggered: {
            ele.visible = true
            logoPage.visible = false
        }
    }

//    CallDialog {
//       id: callDialog
//    }


    Connections {
        target: DATAPROVIDER
        onCallEvent: {
            //callDialog.open()
        }
    }

    LogoPage {
        id: logoPage
        anchors.fill: parent
        visible: true
    }

    MainUi {
        id: ele
        anchors.fill: parent
        visible: false
        
        onShowSettingPage: {
            setting.visible = true
            ele.visible = false
        }
   }
   
   SettingPage {
        id: setting
        anchors.fill: parent
        visible: false
        
       onCloseClicked: {
           ele.visible = true
           setting.visible = false
       }

       onMinimizeClicked: {
           ele.visible = true
           setting.visible = false
       }
   }
}
