import QtQuick 2.0
import QtQml 2.2
import "HmiParams.js" as HmiParams
Item {
    id: root

    width: size
    height: size

    property int size: 200               // The size of the circle in pixel
    property real arcBegin: 0            // start arc angle in degree
    property real arcEnd: 270            // end arc angle in degree
    property real arcOffset: 0           // rotation
    property bool isPie: false           // paint a pie instead of an arc
    property bool showBackground: false  // a full circle as a background of the arc
    property real lineWidth: 20          // width of the line
    property string colorCircle: "#027140"
    property string colorBackground: "#779933"
    property string textColor: "#FFFFFF"
    property real curArcEnd: 270            // end arc angle in degree
    property int minValue: 0
    property int maxValue: 360
    property int value: -1

    property real curvalue: 0
    property int animationDuration: 20

    property int startPoint: -90

    onValueChanged: {
        arcBegin = 0;
        curvalue =(360/(maxValue-minValue))*value
        animationDuration = ((Math.abs(curArcEnd - curvalue)*100)/HmiParams.SCREEN_FREAMERATE);
        arcEnd = curvalue
        curArcEnd = curvalue;
    }

    property alias beginAnimation: animationArcBegin.enabled
    property alias endAnimation: animationArcEnd.enabled

    onArcBeginChanged: canvas.requestPaint()
    onArcEndChanged: canvas.requestPaint()

    Behavior on arcBegin {
       id: animationArcBegin
       enabled: true
       NumberAnimation {
           duration: root.animationDuration
           easing.type: Easing.InOutCubic
       }
    }

    Behavior on arcEnd {
       id: animationArcEnd
       enabled: true
       NumberAnimation {
           duration: root.animationDuration
           easing.type: Easing.InOutCubic
       }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        rotation: startPoint + parent.arcOffset

        onPaint: {
            var ctx = getContext("2d")
            var x = width / 2
            var y = height / 2
            var start = Math.PI * (parent.arcBegin / 180)
            var end = Math.PI * (parent.arcEnd / 180)
            ctx.reset()

            if (root.isPie) {
                if (root.showBackground) {
                    ctx.beginPath()
                    ctx.fillStyle = root.colorBackground
                    ctx.moveTo(x, y)
                    ctx.arc(x, y, width / 2, 0, Math.PI * 2, false)
                    ctx.lineTo(x, y)
                    ctx.fill()
                }
                ctx.beginPath()
                ctx.fillStyle = root.colorCircle
                ctx.moveTo(x, y)
                ctx.arc(x, y, width / 2, start, end, false)
                ctx.lineTo(x, y)
                ctx.fill()
            } else {
                if (root.showBackground) {
                    ctx.beginPath();
                    ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, 0, Math.PI * 2, false)
                    ctx.lineWidth = root.lineWidth
                    ctx.strokeStyle = root.colorBackground
                    ctx.stroke()
                }
                ctx.beginPath();
                ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, start, end, false)
                ctx.lineWidth = root.lineWidth
                ctx.strokeStyle = root.colorCircle
                ctx.stroke()
            }
        }
    }

    Text {
        id: valueText
        text: value

        anchors.centerIn: parent
        font.family: "Avenir Next LT"
        font.pixelSize: 20
        color: textColor
        visible: value != -1
    }
}
