#ifndef FLOWERHANDLER_H
#define FLOWERHANDLER_H

#include <QObject>
#include <QImage>
#include <QRgb>
#include <QDebug>
#include <QThread>
#include <qvariant.h>

#include "opencv2/opencv.hpp"


using namespace cv;

class WorkerThread : public QThread
{

    Q_OBJECT
public:
    explicit WorkerThread(VideoCapture *cap);
    void run();
    VideoCapture * cap;
    int rows, columns;

signals:
    void frameComplete(QList<int> flowers, QList<int> closed);
};



class FlowerHandler: public QObject
{
    Q_OBJECT
public:
    explicit FlowerHandler(QObject *parent = 0);
    VideoCapture * cap;
    WorkerThread * worker;
    int rows, columns;


signals:
    void updateGrid(QList<int> openedFlowers, QList<int> closedFlowers);

public slots:
    void gridCompleted(int rows, int columns);
    void sendGrid(QList<int> openedFlowers, QList<int> closedFlowers);

};


#endif // FLOWERHANDLER_H
