#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace std;
using namespace cv;

// warp images
void main()
{
	float w = 250, h = 350;

	string path = "../Resources/cards.jpg";
	Mat img = imread(path);
	Mat matrix, imgWarp;

	Point2f src[4] = { {529, 142}, {771, 190}, {405, 395}, {674, 457} };
	Point2f dst[4] = { {0.0f, 0.0f}, {w, 0.0f}, {0.0f, h}, {w, h} };
	
	//透视变换
	matrix = getPerspectiveTransform(src, dst); //计算变换矩阵
	warpPerspective(img, imgWarp, matrix, Point(w, h));

	// 绘制图像中纸牌的四个点
	for (int i = 0; i < 4; i++)
	{
		circle(img, src[i], 10, Scalar(0, 69, 255), 5);
	}

	imshow("image", img);
	imshow("image warp", imgWarp);
	waitKey(0);
}
