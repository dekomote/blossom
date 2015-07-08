#include "flowerhandler.h"

#include <iostream>
#include <sstream>

using namespace cv;
using namespace std;


FlowerHandler::FlowerHandler(QObject *parent) :
    QObject(parent)
{
    frameBuffer = NULL;
}


void FlowerHandler::gridCompleted(int rows, int columns)
{
    if(cap.isOpened()) {
        cap.release();
    }
    else {
        cap.open(0);
    }

    if(!cap.isOpened())
        return;

    for(;;) {
        cap.read(frame);
//        BackgroundSubtractorMOG2 fgbg;
//        Mat fore;
//        Mat back;

//        fgbg.operator ()(frame, fore);
//        fgbg.getBackgroundImage(back);

//        erode(fore, fore, Mat());
//        dilate(fore, fore, Mat());

        imshow("Frame", frame);
//        imshow("Foreground", fore);
//        imshow("Background", back);
    }

//    QList<int> openedFlowers;
//    QRgb mask = (255, 255, 255);

//    frameBuffer = new QImage("qml/Blossom/images/sample.png");
//    QImage scaled = frameBuffer->scaled(columns, rows, Qt::IgnoreAspectRatio, Qt::FastTransformation);

//    for(int i = 0; i < scaled.width(); i++) {
//        for(int j = 0; j < scaled.height(); j++) {
//            if(scaled.pixel(i, j) > 4278190080){
//                openedFlowers << j << i;
//            }
//        }
//    }

//    updateGrid(openedFlowers);
}
