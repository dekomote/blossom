#ifndef FLOWERHANDLER_H
#define FLOWERHANDLER_H

#include <QObject>
#include <QImage>
#include <QRgb>
#include <QDebug>
#include <qvariant.h>

#include "opencv2/opencv.hpp"


using namespace cv;

class FlowerHandler: public QObject
{
    Q_OBJECT
public:
    explicit FlowerHandler(QObject *parent = 0);
    QImage * frameBuffer;
    VideoCapture cap;
    Mat frame;


signals:
    void updateGrid(QList<int> openedFlowers);

public slots:
    void gridCompleted(int rows, int columns);

};
#endif // FLOWERHANDLER_H
