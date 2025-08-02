import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import Qt.labs.qmlmodels 1.0
import QtQml.Models 2.2
import com.example.serialmanager 1.0
import QtCharts 2.3  // 添加QtCharts导入

ApplicationWindow {
    width: 1280
    height: 800
    visible: true
    title: qsTr("Hello World")
    id: root
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "#00000000" //背景颜色黑边

    property int dragX: 0
    property int dragY: 0
    // 定义鼠标是否在拖动
    property bool dragging: false
    // 定义矩形的初始状态
    property bool isMaximized: false


    SerialManager {
        id: serialManager
        onPortsChanged: {
        serialPortCombo.model = availablePorts()
        }
    }

    Text {
    id: serialDataText
    text: "串口数据：无数据"
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.margins: 10
    font.pixelSize: 16
    color: "#FFFFFF"
        }

    Connections {
        target: serialManager
        onDataReceived: {
            serialDataText.text = "串口数据：" + data
        }
    }

    Rectangle { // 主背景矩形
        width: parent.width
        height: parent.height
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#4158D0"
            }
            GradientStop {
                position: 1
                color: "#C850C0"
            }
            orientation: Gradient.Horizontal
        }

        // 窗口拖动
        MouseArea {
            width: parent.width
            height: 30
            onPressed: {
                root.dragX = mouseX
                root.dragY = mouseY
                root.dragging = true
            }
            onReleased: root.dragging = false
            onPositionChanged: {
                if (root.dragging) {
                    root.x += mouseX - root.dragX
                    root.y += mouseY - root.dragY
                }
            }
        }
          // 下拉选择框
            ComboBox {
                id: serialPortCombo
                x: closebtn.x - 35 * 5.5
                y: closebtn.y
                width: 120
                height: closebtn.height
                model: serialManager.availablePorts()
                
                // 字体设置
                font {
                    family: "Microsoft YaHei"
                    pixelSize: 14
                    bold: true
                }
                
                // 文本颜色
                palette {
                    text: "#FFFFFF"
                    buttonText: "#FFFFFF"
                    highlight: "#5D9CEC"
                    highlightedText: "#FFFFFF"
                }

                background: Rectangle {
                    radius: 6
                    color: "#40000000"
                    border.color: "#80FFFFFF"
                    border.width: 1
                    // 替代阴影效果
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -1
                        color: "transparent"
                        border.color: "#20000000"
                        border.width: 1
                        radius: 7
                        z: -1
                    }
                }

                // 下拉箭头样式
                indicator: Image {
                    source: "qrc:/icons/com.png" //
                    anchors.right: parent.right
                    anchors.rightMargin: 10 // 设置右边距
                    anchors.verticalCenter: parent.verticalCenter
                    width: 16  // 设置箭头大小
                    height: 16  // 设置箭头大小
                    opacity: 0.8// 设置透明度
                }

                // 弹出菜单样式
                popup: Popup {
                    y: serialPortCombo.height + 2
                    width: serialPortCombo.width
                    implicitHeight: Math.min(contentHeight, 200)
                    padding: 4
                    onOpened: {
                    serialManager.refreshPorts()
                    }
                    
                  background: Rectangle {
                        radius: 6
                        color: "#40000000"
                        border.color: "#80FFFFFF"
                        border.width: 1
                        // 替代阴影效果
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: -1
                            color: "transparent"
                            border.color: "#20000000"
                            border.width: 1
                            radius: 7
                            z: -1
                        }
                    }

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: serialPortCombo.popup.visible ? serialPortCombo.delegateModel : null
                        currentIndex: serialPortCombo.highlightedIndex
                        
                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                            width: 6
                        }
                    }
                }

                // 下拉项样式
                delegate: ItemDelegate {
                    width: parent.width
                    height: 32
                    highlighted: serialPortCombo.highlightedIndex === index
                    
                    contentItem: Text {
                        text: modelData
                        font: serialPortCombo.font
                        color: highlighted ? "#FFFFFF" : "#E0E0E0"
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
                    }
                    
                    background: Rectangle {
                        color: highlighted ? "#5D9CEC" : "transparent"
                        radius: 4
                    }
                }

                // 当前选中项显示
                contentItem: Text {
                    text: serialPortCombo.displayText
                    font: serialPortCombo.font
                    color: serialPortCombo.palette.text
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    leftPadding: 12
                    rightPadding: serialPortCombo.indicator.width + 10
                }

                // 保留原有业务逻辑
                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        if (serialManager.isOpen()) {
                            serialManager.closeSerialPort();
                        }
                        serialManager.openSerialPort(model[currentIndex]);
                    }
                }
            }
             // 电压电流折线图
              Item {
                anchors {
                    top: parent.top
                    topMargin: parent.height / 2 +40
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: 20
                }
                    height: parent.height * 0.7  // 增加高度比例
                    width: parent.width * 0.98    // 增加宽度比例

                ChartView {
                    id: chart
                    animationOptions: ChartView.NoAnimation
                    // animationOptions: ChartView.AllAnimations
                    // animationDuration: 300  // 设置为300ms的动画时间
                    anchors.fill: parent
                    theme: ChartView.ChartThemeDark
                    // animationDuration: 1000
        
                    antialiasing: true
                    legend.visible: true
                    legend.alignment: Qt.AlignBottom        
                    margins {
                        left: 40
                        right: 20
                        top: 10
                        bottom: 20
                    }
                     Component.onCompleted: {
                        // 初始化时添加0值数据点
                        var timestamp = new Date().getTime();
                        voltageSeries.append(timestamp, 0);
                        currentSeries.append(timestamp, 0);
                        
                        // 设置初始时间轴范围
                        timeAxis.min = new Date(timestamp - 10000);
                        timeAxis.max = new Date(timestamp);
                    }

                    // 电压曲线
                    LineSeries {
                        id: voltageSeries
                        name: "电压(V)"
                        axisX: timeAxis
                        axisY: valueAxis
                        color: "#FF5733"
                        width: 2
                        pointsVisible: false
                        // 添加悬停提示
                        onHovered: (point, state) => {
                            if (state) {
                                chart.toolTip = "时间: " + Qt.formatDateTime(new Date(point.x), "hh:mm:ss") + 
                                            "\n电压: " + point.y.toFixed(2) + "V";
                                chart.toolTipVisible = true;
                            } else {
                                chart.toolTipVisible = false;
                            }
                        }

                    }

                    // 电流曲线
                    LineSeries {
                        id: currentSeries
                        name: "电流(A)"
                        axisX: timeAxis
                        axisY: valueAxis
                        color: "#33FF57"
                        width: 2
                        pointsVisible: false
                         // 添加悬停提示
                        onHovered: (point, state) => {
                            if (state) {
                                chart.toolTip = "时间: " + Qt.formatDateTime(new Date(point.x), "hh:mm:ss") + 
                                            "\n电流: " + point.y.toFixed(2) + "A";
                                chart.toolTipVisible = true;
                            } else {
                                chart.toolTipVisible = false;
                            }
                        }
                    }

                    DateTimeAxis {
                        id: timeAxis
                        format: "hh:mm:ss"
                        tickCount: 10  // 保持固定刻度数量
                        labelsAngle: 0
                        titleText: "时间"
                        // 移除固定的min/max设置，允许动态变化
                    }
                    // Y轴(数值)
                    ValueAxis {
                        id: valueAxis
                        min: 0
                        max: 15 // 固定范围(0-15)
                        tickCount: 6 // 固定刻度数量
                        labelFormat: "%.3f"
                        titleText: "数值"
                        minorTickCount: 0 // 禁用次要刻度线
                        labelsVisible: true
                        gridVisible: true
                        lineVisible: true
                    }
                }
            }
            // 电压表 - 左侧
            Item {
                id: voltageItem  // 添加这行
                anchors.left: parent.left
                anchors.leftMargin: parent.width *0.1  // 调整宽度边距
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.35
                height: parent.height * 0.5

                // 表头标签（居中显示）
                Text {
                    id: voltageLabel  // 添加 id
                    z: 1  // 确保文本在底层
                    text: "电压表 (V)"
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: parent.height / 3  // 1/2处
                        // 或者使用 parent.height / 3 表示1/3处
                    }
                    font.pixelSize: 20
                    color: "white"
                }
                // 电压值显示
                Text {
                    id: voltageValueLabel  // 添加 id
                    z: 1
                    text: voltagegauge.value.toFixed(3) + " V"
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: parent.height / 3 - 30 // 1/2处
                    }
                    font.pixelSize: 24
                    color: "white"
                }
                CircularGauge {
                    id: voltagegauge
                    z: 2  // 确保指针在上层
                    anchors{
                        fill: parent
                        bottomMargin: parent.height * 0.1  // 增加底部边距
                        }
                    value: 0
                    minimumValue: 0
                    maximumValue: 15 // 最大电压值
                    
                    Behavior on value {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutQuad
                        }
                    }
                    
                    // 样式指针样式   
                    // bottomMargin: -outerRadius * 0.1  // 改为相对边距     
                    style: CircularGaugeStyle {
                        minimumValueAngle: -85
                        maximumValueAngle: 85
                        tickmarkStepSize: 1
                        needle: Item {
                            width: outerRadius * 2
                            height: outerRadius * 2
                            anchors.centerIn: parent
                            
                            Image {
                                source: "qrc:/icons/needle.png"
                                width: parent.width * 0.05  // 改为相对宽度
                                height: outerRadius * 0.9
                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    bottom: parent.verticalCenter
                                    bottomMargin: -outerRadius * 1  // 改为相对边距 
                                }
                                antialiasing: true
                                transformOrigin: Item.Bottom
                            }
                        }
                    }
                                
                }
            }

            // 电流表 - 右侧
            Item {  
                //https://blog.csdn.net/lsylovezsl/article/details/126421445
                id: currentItem  // 添加 id
                anchors.left: voltageItem.right
                anchors.leftMargin: parent.width * 0.1  // 与左边距相同，保持等比间距
                anchors.verticalCenter: parent.verticalCenter
                width: voltageItem.width 
                height: voltageItem.height 

                // 表头标签（居中显示）
                Text {
                    z: 1
                    id: currentLabel  // 添加 id
                    text: "电流表 (A)"
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: parent.height / 3  // 1/2处
                        // 或者使用 parent.height / 3 表示1/3处
                    }
                    font.pixelSize: 20
                    color: "white"
                }
                // 添加电流值显示
                Text {
                    z: 1
                    id: currentValueLabel  // 添加 id
                    text: currentgauge.value.toFixed(3) + " A"
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: parent.height / 3 - 30 // 1/2处
                    }
                    font.pixelSize: 24
                    color: "white"
                }

                CircularGauge {
                    id:currentgauge
                    z: 2
                   anchors {
                    fill: parent
                    bottomMargin: parent.height * 0.1  // 添加与电压表相同的底部边距
                            }
                    value: 0
                    minimumValue: 0
                    maximumValue: 5
                    
                    Behavior on value {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutQuad
                        }
                    }
                    
                    style: voltagegauge.style
                }
            }

            Connections {
                target: serialManager
           

                onJsonDataReceived: {
                    // 添加数据有效性检查
                    if(isNaN(voltage) || isNaN(current)) return;
                    
                    // 直接更新仪表值
                    voltagegauge.value = voltage;
                    currentgauge.value = current;
                    serialDataText.text = "电流: " + current.toFixed(3) + "A, 电压: " + voltage.toFixed(3) + "V";
                    
                    // 获取当前时间戳
                    var timestamp = new Date().getTime();
                    
                    // 更新折线图数据
                    voltageSeries.append(timestamp, voltage);
                    currentSeries.append(timestamp, current);
                    
                    // // 动态调整时间轴范围（显示最近10秒数据）
                    var minTime = timestamp - 10000; // 10秒前
                    timeAxis.min = new Date(minTime);
                    timeAxis.max = new Date(timestamp);
                  
              
                     // 优化时间轴更新频率
                    if(timestamp > timeAxis.max.getTime() + 2000) {  // 仅当超出当前范围2秒时才更新
                        timeAxis.min = new Date(timestamp - 10000);
                        timeAxis.max = new Date(timestamp);
                    }
                    
                    // 增加数据点保留数量
                    if(voltageSeries.count > 1000) {  // 增加到保留1000个数据点
                        voltageSeries.removePoints(0, voltageSeries.count - 1000);
                        currentSeries.removePoints(0, currentSeries.count - 1000);
                    }
                }
            }





    }//主题背景



    // 关闭窗口按钮
    Rectangle {
        id: closebtn
        x: root.width - 35
        y: root.height - root.height + 5
        width: 30
        height: 30
        color: "#00000000"
        radius: 10
        Image {
            source: "qrc:/icons/close.png"
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true  // 开启鼠标区域监听
            onEntered: parent.color = "red"
            onExited: parent.color = "#00000000"
            onClicked: root.close()
        }
    }

    Rectangle { // 大化小化
        id: minmaxBtn
        x: closebtn.x - 35
        y: closebtn.y
        z: closebtn.z
        width: 30
        height: 30
        color: "#00000000"
        radius: closebtn.radius
        Image {
            source: root.visibility === Window.Windowed ? "qrc:/icons/maxsize.png" : "qrc:/icons/normal.png"
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true  // 开启鼠标区域监听
            onEntered: parent.color = "#1BFFFFFF"
            onExited: parent.color = "#00000000"
            onClicked: {
                if (root.visibility === Window.Windowed) {
                    root.visibility = Window.Maximized;
                } else {
                    root.visibility = Window.Windowed;
                }
            }
        }
    }

    Rectangle { // 回到任务栏
        x: closebtn.x - 35 * 2
        y: closebtn.y
        z: closebtn.z
        width: 30
        height: 30
        color: "#00000000"
        radius: closebtn.radius
        Image {
            source: "qrc:/icons/minium.png"
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true  // 开启鼠标区域监听
            onEntered: parent.color = "#1BFFFFFF"
            onExited: parent.color = "#00000000"
            onClicked: {
                root.visibility = Window.Minimized; // 最小化窗口
            }
        }
    }
}
