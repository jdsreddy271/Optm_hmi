#include <QApplication>
#include <QProcess>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include <QString>


#include "hmidatahandler.h"
#include "platformcomm.h"

int main(int argc, char *argv[])
{

    // settings environment variable (width, height) for application
    if (qEnvironmentVariableIsEmpty("QTGLESSTREAM_DISPLAY"))
    {
        qputenv("QT_QPA_EGLFS_PHYSICAL_WIDTH", QByteArray("800"));
        qputenv("QT_QPA_EGLFS_PHYSICAL_HEIGHT", QByteArray("480"));
        QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    }

    // Creating QApplication instance
    QApplication app(argc, argv);

    // seting application details(org name,domain,application name)
    QApplication::setOrganizationName("Optm");
    QApplication::setOrganizationDomain("https://Optmsol.com");
    QApplication::setApplicationName("Optm");

    // Creating instance/object for HmiDataHandler class(For sending data to QML)
    HmiDataHandler  pHmiData;

    // Creating instance/object for QQmlApplicationEngine (creating QML engine)
    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    // Exporting pHmiData object to QML by settings as context property(For accessing data in QML)
    engine.rootContext()->setContextProperty("DATAPROVIDER", &pHmiData);
    engine.load(url);   // loading main.qml

//    // Creating thread
//    PlatformComm plfThread(nullptr);
//    // Connecting thread & hmidata for sending data
//    QObject::connect(&plfThread, SIGNAL(HmiMessageReceived(const QVariant&, int)),&pHmiData,
//                                        SLOT(slotHmiMessageReceived(const QVariant&, int)));

//    // starting thread
//    plfThread.start();

    return app.exec();
}
