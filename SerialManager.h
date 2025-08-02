#ifndef SERIALMANAGER_H
#define SERIALMANAGER_H

#include <QObject>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QTimer>
// 添加以下两个头文件 ↓
#include <QJsonDocument>
#include <QJsonObject>

class SerialManager : public QObject
{
    Q_OBJECT
public:
    explicit SerialManager(QObject *parent = nullptr);

    Q_INVOKABLE void openSerialPort(const QString &portName);
    Q_INVOKABLE void closeSerialPort();
    Q_INVOKABLE QStringList availablePorts() const;
    Q_INVOKABLE bool isOpen() const;
    Q_INVOKABLE void refreshPorts(); // 新增刷新方法

signals:
    void dataReceived(const QString &data);
    void portsChanged(); // 新增端口变化信号
    void jsonDataReceived(double current, double voltage); // 新增信号

private slots:
    void checkPorts(); // 检查端口变化

private:
    QSerialPort serial;
    QTimer* portsCheckTimer; // 定时检查端口
    QStringList lastPortList; // 上次端口列表
};

#endif // SERIALMANAGER_H