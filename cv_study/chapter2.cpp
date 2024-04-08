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

	//ת��Ϊ�Ҷ�ͼ��
	cvtColor(img, imgGray, COLOR_BGR2GRAY);
	//ģ������
	GaussianBlur(img, imgBlur, Size(7, 7), 7, 0);
	//��Ե��ȡ
	Canny(imgBlur, imgCanny, 50, 150);

	Mat kernel = getStructuringElement(MORPH_RECT, Size(5, 5));
	//����
	dilate(imgCanny, imgDilate, kernel);
	//��ʴ
	erode(imgDilate, imgErode, kernel);

	imshow("image", img);
	imshow("image gray", imgGray);
	imshow("image blur", imgBlur);
	imshow("image canny", imgCanny);
	imshow("image dilation", imgDilate);
	imshow("image erode", imgErode);
	waitKey(0);
}