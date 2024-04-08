#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace std;
using namespace cv;

// color detection
void main()
{
	string path = "../Resources/lambo.png";
	Mat img = imread(path);
	Mat imgHSV, mask;
	int hmin = 0, smin = 110, vmin = 153;
	int hmax = 19, smax = 240, vmax = 255;

	//颜色空间转换
	cvtColor(img, imgHSV, COLOR_BGR2HSV);
	
	//创建一个窗口 名为trackbars
	namedWindow("trackbars", (640, 200));
	//在窗口trackbars中创建trackbar 对应某个特定变量
	createTrackbar("hue min", "trackbars", &hmin, 179); 
	createTrackbar("hue max", "trackbars", &hmax, 179); //色相的最大值为179
	createTrackbar("sat min", "trackbars", &smin, 255);
	createTrackbar("sat max", "trackbars", &smax, 255);
	createTrackbar("val min", "trackbars", &vmin, 255);
	createTrackbar("val max", "trackbars", &vmax, 255);

	while (true)
	{
		Scalar lower(hmin, smin, vmin);
		Scalar upper(hmax, smax, vmax);
		// color在规定区域内的像素将被设置为白色（255）
		inRange(imgHSV, lower, upper, mask);

		imshow("image", img);
		imshow("image HSV", imgHSV);
		imshow("image mask", mask);
		waitKey(1);
	}
}
