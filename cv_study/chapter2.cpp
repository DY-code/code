#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

void main()
{
	string path = "../Resources/test.png";
	Mat img = imread(path);
	Mat imgGray;
	Mat imgBlur;
	Mat imgCanny;
	Mat imgDilate, imgErode;

	//转换为灰度图像
	cvtColor(img, imgGray, COLOR_BGR2GRAY);
	//模糊处理
	GaussianBlur(img, imgBlur, Size(7, 7), 7, 0);
	//边缘提取
	Canny(imgBlur, imgCanny, 50, 150);

	Mat kernel = getStructuringElement(MORPH_RECT, Size(5, 5));
	//膨胀
	dilate(imgCanny, imgDilate, kernel);
	//腐蚀
	erode(imgDilate, imgErode, kernel);

	imshow("image", img);
	imshow("image gray", imgGray);
	imshow("image blur", imgBlur);
	imshow("image canny", imgCanny);
	imshow("image dilation", imgDilate);
	imshow("image erode", imgErode);
	waitKey(0);
}