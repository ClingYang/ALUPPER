#include "SerialManager.h"
#include <QDebug>


SerialManager::SerialManager(QObject *parent)
    : QObject(parent)
{
    connect(&serial, &QSerialPort::readyRead, this, [this]() {
        QByteArray rawData = serial.readAll();
        QString data = QString::fromUtf8(rawData);
//        qDebug() << "Received data:" << data; // 打印接收到的数据
            // 尝试解析JSON
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8(), &error);
        if (error.error == QJsonParseError::NoError && doc.isObject()) {
            QJsonObject obj = doc.object();
            double current = obj.value("current").toDouble();
            double voltage = obj.value("voltage").toDouble();
            emit jsonDataReceived(current, voltage); // 发射解析后的数据
        } else {
            emit dataReceived(data); // 保持原有文本数据发射
        }
    });

     // 初始化定时器
     portsCheckTimer = new QTimer(this);
     connect(portsCheckTimer, &QTimer::timeout, this, &SerialManager::checkPorts);
     portsCheckTimer->start(1000); // 每秒检查一次
     lastPortList = availablePorts(); // 初始化端口列表
}

void SerialManager::openSerialPort(const QString &portName)
{
    if (serial.isOpen()) {
        qDebug() << "Closing serial port:" << serial.portName();
        serial.close();  // 如果已有串口打开，则先关闭
    }

    serial.setPortName(portName);
    serial.setBaudRate(QSerialPort::Baud115200);
    serial.setDataBits(QSerialPort::Data8);
    serial.setParity(QSerialPort::NoParity);
    serial.setStopBits(QSerialPort::OneStop);
    serial.setFlowControl(QSerialPort::NoFlowControl);

    if (serial.open(QIODevice::ReadOnly)) {
        qDebug() << "Serial port opened:" << portName;
    } else {
        qDebug() << "Failed to open serial port:" << portName;
    }
}

void SerialManager::closeSerialPort()
{
    if (serial.isOpen()) {
        QString portName = serial.portName();
        serial.close();
        qDebug() << "Serial port closed:" << portName;
    }
}

void SerialManager::checkPorts()
{
    QStringList currentPorts = availablePorts();
    if(currentPorts != lastPortList) {
        lastPortList = currentPorts;
        emit portsChanged(); // 端口变化时发出信号
    }
}
void SerialManager::refreshPorts()
{
    lastPortList = availablePorts();
    emit portsChanged();
}
QStringList SerialManager::availablePorts() const
{
    QStringList ports;
    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts()) {
        ports << info.portName();
    }
    return ports;
}

bool SerialManager::isOpen() const
{
    return serial.isOpen();
}
