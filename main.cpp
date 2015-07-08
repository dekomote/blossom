#include <QtGui/QGuiApplication>
#include <QQuickItem>
#include <QQmlContext>
#include <QObject>
#include <QImage>

#include "qtquick2applicationviewer.h"
#include "flowerhandler.h"
#include <unistd.h>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    QQmlContext* ctx = viewer.rootContext();
    FlowerHandler flowerHandler;
    ctx->setContextProperty("flowerHandler", &flowerHandler);
    viewer.setMainQmlFile(QStringLiteral("qml/Blossom/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
