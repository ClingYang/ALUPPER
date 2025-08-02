// #include <QGuiApplication>
#include <QApplication>  // 替换原来的QGuiApplication
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QtCharts> // 添加QtCharts头文件
// 自定义库头文件
#include "SerialManager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    // 注册 SerialManager 到 QML
    qmlRegisterType<SerialManager>("com.example.serialmanager", 1, 0, "SerialManager");

    // QGuiApplication app(argc, argv);
    QApplication app(argc, argv);  // 替换原来的QGuiApplication
    app.setWindowIcon(QIcon(":/icons/App_2.png")); // 设置应用程序图标

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
                     {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
