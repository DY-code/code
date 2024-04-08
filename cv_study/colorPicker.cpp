#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>;
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

/*
��ɫ��
156,134,193
179,255,255
*/

//��ȡɫ�����ֵ
int main()
{
	int hmin = 0, smin = 0, vmin = 0;
	int hmax = 255, smax = 255, vmax = 255;

	VideoCapture cap(0);
	Mat imgHSV, mask, imgColor;
	Mat img;

	namedWindow("trackbars", (640, 200)); //create window 
	createTrackbar("hue min", "trackbars", &hmin, 179);
	createTrackbar("hue max", "trackbars", &hmax, 179);
	createTrackbar("sat min", "trackbars", &smin, 255);
	createTrackbar("sat max", "trackbars", &smax, 255);
	createTrackbar("val min", "trackbars", &vmin, 255);
	createTrackbar("val max", "trackbars", &vmax, 255);

	while (true)
	{
		cap.read(img);
		cvtColor(img, imgHSV, COLOR_BGR2HSV);

		Scalar lower(hmin, smin, vmin);
		Scalar upper(hmax, smax, vmax);

		//��ȡͼƬ��ָ����ɫ�ռ��mask ��ɫΪ��Ч
		inRange(imgHSV, lower, upper, mask);
		//bitwise_and(img, img, imgColor, mask = mask);
		cout << hmin << "," << smin << "," << vmin << endl;
		cout << hmax << "," << smax << "," << vmax << endl;

		imshow("image", img);
		imshow("mask", mask);
		//imshow("image color", imgColor);

		waitKey(1);
	}

}
