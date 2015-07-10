#include "flowerhandler.h"

#include <iostream>
#include <sstream>

using namespace cv;
using namespace std;

WorkerThread::WorkerThread(VideoCapture * capture)
{
    cap = capture;
}

void WorkerThread::run()
{
    Mat frame;

    if(cap->isOpened()) {
        cap->release();
    }
    else {
        cap->open(0);
    }

    if(!cap->isOpened())
        return;

    BackgroundSubtractorMOG* fgbg = new BackgroundSubtractorMOG(500, 3, 0.4, 0);
    Mat kernel = getStructuringElement(MORPH_ELLIPSE, Point(3,3));
    Mat fore;
    QList<int> openedFlowers;
    QList<int> closedFlowers;


    for(;;){
        openedFlowers.clear();
        closedFlowers.clear();
        cap->read(frame);
        fgbg->operator ()(frame, fore);
        morphologyEx(fore, fore, MORPH_CLOSE, kernel);
        imshow("Foreground", fore);
        resize(fore, fore, Size(columns, rows), INTER_NEAREST);
        for(int i=0; i<columns; i++){
            for(int j=0; j<rows; j++){
                if(fore.at<uchar>(Point(i, j)) >= 127)
                    openedFlowers << j << i;
                else
                    closedFlowers << j << i;
            }
        }
        frameComplete(openedFlowers, closedFlowers);
    }
}


FlowerHandler::FlowerHandler(QObject *parent) :
    QObject(parent)
{
    cap = new VideoCapture(0);
    worker = new WorkerThread(cap);
    columns = 0;
    rows = 0;
}


void FlowerHandler::gridCompleted(int rws, int cls)
{
    rows = rws;
    columns = cls;

    if(worker->isRunning())
        worker->terminate();
    connect(worker, SIGNAL(frameComplete(QList<int>, QList<int>)), this, SLOT(sendGrid(QList<int>, QList<int>)));
    worker->rows = rows;
    worker->columns = columns;
    worker->start();

}

void FlowerHandler::sendGrid(QList<int> openedFlowers, QList<int> closedFlowers)
{
    updateGrid(openedFlowers, closedFlowers);
}
