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

	//��ɫ�ռ�ת��
	cvtColor(img, imgHSV, COLOR_BGR2HSV);
	
	//����һ������ ��Ϊtrackbars
	namedWindow("trackbars", (640, 200));
	//�ڴ���trackbars�д���trackbar ��Ӧĳ���ض�����
	createTrackbar("hue min", "trackbars", &hmin, 179); 
	createTrackbar("hue max", "trackbars", &hmax, 179); //ɫ������ֵΪ179
	createTrackbar("sat min", "trackbars", &smin, 255);
	createTrackbar("sat max", "trackbars", &smax, 255);
	createTrackbar("val min", "trackbars", &vmin, 255);
	createTrackbar("val max", "trackbars", &vmax, 255);

	while (true)
	{
		Scalar lower(hmin, smin, vmin);
		Scalar upper(hmax, smax, vmax);
		// color�ڹ涨�����ڵ����ؽ�������Ϊ��ɫ��255��
		inRange(imgHSV, lower, upper, mask);

		imshow("image", img);
		imshow("image HSV", imgHSV);
		imshow("image mask", mask);
		waitKey(1);
	}
}
