import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

ApplicationWindow  {
    width: 1280
    height: 800
    visible: true
    title: qsTr("Hello World")
    id:root
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "#00000000" //背景颜色黑边

    property int dragX: 0
    property int dragY: 0
    // 定义鼠标是否在拖动
    property bool dragging: false
    // 定义矩形的初始状态
    property bool isMaximized: false

    Rectangle //主背景矩形
    {
        width:parent.width
        height:parent.height
//        color: "red"
        gradient: Gradient
        {
            GradientStop //开始颜色
            {
                position:0
                color:"#4158D0"
            }
            GradientStop //开始颜色
            {
                position:1
                color:"#C850C0"
            }
            orientation:Gradient.Horizontal

        }
        radius: 10
        // 窗口拖动
        MouseArea
        {
            width:parent.width
            height: 30
            onPressed:
            {
                root.dragX = mouseX
                root.dragY = mouseY
                root.dragging = true

            }
            onReleased:root.dragging = false
            onPositionChanged:
            {
                if(root.dragging)
                {
                    root.x+= mouseX - root.dragX
                    root.y+= mouseY - root.dragY

                }
            }

        }

       Rectangle
       {
           width: 800
           height: 500
           //居中布局
            anchors.centerIn:parent //居中于父节点
            radius:10
            Image {
//                id: /*name*/
                source: "qrc:/icons/app.png"
            }
            Text
            {
    //            id: Text1
                x:530
                y:130
                width:120
                height: 30
                font.pixelSize: 25
                text: qsTr("登入系统")
            }
            TextField{
                id:username
                x:220
                y:150
                width:300
                height: 50
                font.pixelSize: 25
            }
        }


    }
    Rectangle // 关闭窗口按钮
    {
        id:closebtn
         x:root.width-35
         y:root.height-root.height+5
         width:30
         height:30
         color:"#00000000"
         radius:15
         Image{

           source: "qrc:/icons/close.png"
           anchors.centerIn: parent
         }
         MouseArea
         {
            anchors.fill:parent
            hoverEnabled: true  //开启鼠标区域监听
            onEntered: parent.color = "red"
            onExited: parent.color = "#00000000"
            onPressed: parent.color = "#3BFFFFFF"
            onReleased: parent.color = "#1BFFFFFF"
            onClicked:  root.close()
         }
    }
    Rectangle{ //大化小化
         id:minmaxBtn
         x:closebtn.x-35
         y:closebtn.y
         z:closebtn.z
         width:30
         height:30
         color:"#00000000"
         radius:15
        Image {
            source: root.visibility === Window.Windowed ? "qrc:/icons/maxsize.png": "qrc:/icons/normal.png" 
            anchors.centerIn: parent
        }
         MouseArea
         {
            anchors.fill:parent
            hoverEnabled: true  //开启鼠标区域监听
            onEntered: parent.color = "#1BFFFFFF"
            onExited: parent.color = "#00000000"
            onPressed: parent.color = "#3BFFFFFF"
            onReleased: parent.color = "#1BFFFFFF"
            onClicked: {
                if (root.visibility === Window.Windowed) {
                    root.visibility = Window.Maximized;
                    
                } else {
                    root.visibility = Window.Windowed;
                }
            }
         }
    }
    Rectangle{ // 回到任务栏
        x:minmaxBtn.x-35
        y:minmaxBtn.y
        z:minmaxBtn.z
        width:30
        height:30
        color:"#00000000"
        radius:15
       Image{

          source: "qrc:/icons/minium.png"
          anchors.centerIn: parent
        }
        MouseArea
        {
           anchors.fill:parent
           hoverEnabled: true  //开启鼠标区域监听
           onEntered: parent.color = "#1BFFFFFF"
           onExited: parent.color = "#00000000"
           onPressed: parent.color = "#3BFFFFFF"
           onReleased: parent.color = "#1BFFFFFF"
           onClicked:{
             root.visibility = Window.Minimized; // 最小化窗口
           }   
        }
    }


}//窗口
