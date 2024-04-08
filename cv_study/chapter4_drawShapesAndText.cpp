#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace std;
using namespace cv; 

//draw shapes and text
void main()
{
	// blank image
	Mat img(512, 512, CV_8UC3, Scalar(255, 255, 255));

	// draw circle
	//circle(img, Point(256, 256), 155, Scalar(0, 69, 255), 10);
	circle(img, Point(256, 256), 155, Scalar(0, 69, 255), FILLED); //填充 

	// draw rectangle
	// 给出矩形左上角和左下角的点的坐标
	//rectangle(img, Point(256-155, 256-155), Point(256 + 155, 256 + 155), Scalar(0, 0, 0), 3);
	rectangle(img, Point(130, 226), Point(382, 286), Scalar(255, 255, 255), FILLED);  //填充

	// draw line  start point + end point
	line(img, Point(130, 296), Point(382, 296), Scalar(255, 255, 255), 2);

	// put text
	putText(img, "Murtaza's Workshop", Point(137, 262), FONT_HERSHEY_DUPLEX, 0.75, Scalar(0, 69, 255), 2);
 
	imshow("image", img);
	waitKey(0);
}
