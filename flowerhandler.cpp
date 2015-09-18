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

	BackgroundSubtractorMOG2* fgbg = new BackgroundSubtractorMOG2(50000, 30, false);
    Mat fore;
	Mat person;
    for(int k=0;k<15;k++)
        cap->read(fore);
	cvtColor(fore, fore, CV_RGB2GRAY);
    QList<int> openedFlowers;
    QList<int> closedFlowers;


    for(;;){
        openedFlowers.clear();
        closedFlowers.clear();
        cap->read(frame);
		cvtColor(frame, frame, CV_RGB2GRAY);
		absdiff(frame, fore, person );
		threshold(person, person, 30, 255, THRESH_BINARY);
		//fgbg->operator ()(frame, fore);
		//morphologyEx(fore, fore, MORPH_CLOSE, kernel);
        //imshow("Foreground", person);
		resize(person, person, Size(columns, rows), INTER_NEAREST);
		for(int i=0; i<columns; i++){
			for(int j=0; j<rows; j++){
				if(person.at<uchar>(Point(i, j)) >= 127)
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
