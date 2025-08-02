import QtQuick 2.3
import QtCharts 2.1
import QtQuick.Controls 2.0
 
ChartView {
    id : myChartview
    legend.visible:false
    animationOptions: ChartView.NoAnimation
    antialiasing: true
    backgroundColor: "#939393"
    titleColor: "#000000"
    property var m_min_Y_L: 0
    property var m_max_Y_L: 1
    property var m_sLegent1: qsTr("")
    property var m_color : "red"
    property var m_seriesWidth1: 3    //线宽
    property var m_line1Color : "blue"
    property bool m_bTitleVisible :false
    property bool m_bAxis1 : true
 
    property var objectLine1:lineSeries1
    property var objectLine2:lineSeries2
    property var objectLine3:lineSeries3
    property int maxXaxis : 300
    property int minXaxis : 0
 
    property var _valueL:0
 
 
    Component.onCompleted:
    {
 
    }
 
    function hoverShowText(type,data,_color)
    {
        m_color = _color;
        if(type)
        {
            dataNameValue.text = String(data.toFixed(2))
            dataNameValue.visible = true
        }else
            dataNameValue.visible = false
    }
 
    ValueAxis{
        id:                 axisX
        min:                minXaxis
        max:                maxXaxis
        tickCount:          3
        minorTickCount:     0
        color:              titleColor
        labelsColor:        titleColor
        minorGridLineColor: titleColor
        titleVisible:       true
        titleBrush:         titleColor
 
    }
 
    ValueAxis{
        id:             axisY_L
        min:            m_min_Y_L
        max:            m_max_Y_L
        labelsColor:   lineSeries1.color
        color:          titleColor
        titleText:      m_sLegent1
        titleVisible:   true
        titleBrush:     lineSeries1.color
        visible:        m_bAxis1
    }
 
 
 
    Label{
        id:            titleLabelL
        text:          m_sLegent1
        color:         lineSeries1.color
        anchors.left:   parent.left
        anchors.leftMargin:   30
        anchors.top:        parent.top
        anchors.topMargin: 30
        horizontalAlignment:    Text.AlignLeft
        verticalAlignment:      Text.AlignVCenter
        wrapMode:               Text.WordWrap
        font.pixelSize: 20
    }
    Label{
        id: _lab1
        visible: m_bTitleVisible
        color:lineSeries1.color
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.left: titleLabelL.right
        anchors.leftMargin: 30
        text:_valueL.toFixed(2)
        font.pixelSize: 20
    }
 
    LineSeries {
        id: lineSeries1
        axisX: axisX
        axisY: axisY_L
        width: m_seriesWidth1
        color: m_line1Color
        onHovered:hoverShowText(state,point.y,lineSeries1.color)
    }
 
    // 第二条线
    LineSeries {
        id: lineSeries2
        axisX: axisX
        axisY: axisY_L
        width: m_seriesWidth1 // 您可能需要为每条线设置不同的线宽
        color: "green" // 设置线的颜色
        onHovered: hoverShowText(state,point.y,lineSeries2.color) // 更新悬停处理函数
    }
 
    // 第三条线
    LineSeries {
        id: lineSeries3
        axisX: axisX
        axisY: axisY_L
        width: m_seriesWidth1 // 您可能需要为每条线设置不同的线宽
        color: "orange" // 设置线的颜色
        onHovered: hoverShowText(state, point.y, lineSeries3.color) // 更新悬停处理函数
    }
 
 
    Text {
        id: dataNameValue
        color: m_color
        font.pixelSize: 20
        visible: false
        text: qsTr("")
        x:parent.width/2
        y:10
    }
}
 