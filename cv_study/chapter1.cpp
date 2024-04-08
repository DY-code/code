#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

void main()
{
	/*读取图像*/
	//string path = "../Resources/test.png";
	//Mat img = imread(path);
	//imshow("Image", img);
	//waitKey(0);


	/*读取视频*/
	//string path = "../Resources/test_video.mp4";
	//VideoCapture cap(path);
	//Mat img;

	//while (true)
	//{
	//	cap.read(img);
	//	imshow("image", img);
	//	waitKey(20);
	//}


	/*摄像头 webcam*/
	VideoCapture cap(0);
	Mat img;

	while (true)
	{
		cap.read(img);
		imshow("image", img);
		waitKey(1);
	}
}
