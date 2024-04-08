#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

//预处理
Mat preProcessing(Mat img)
{
	Mat imgGray, imgBlur, imgCanny, imgDilation;
	cvtColor(img, imgGray, COLOR_BGR2GRAY);

	GaussianBlur(imgGray, imgBlur, Size(3, 3), 3, 0);
	Canny(imgBlur, imgCanny, 25, 75);
	//膨胀
	dilate(imgCanny, imgDilation, getStructuringElement(MORPH_RECT, Size(3, 3)));

	return imgDilation;
}

//获取最大轮廓
vector<Point> getMaxContour(Mat imgPrepro, Mat imgOri)
{
	vector<vector<Point>> contours;
	vector<Vec4i> hierarchy;

	findContours(imgPrepro, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
	vector<vector<Point>> conPoly(contours.size());
	vector<Rect> boundRect(contours.size());

	//最大（面积的）轮廓和面积值
	vector<Point> contourMax;
	int maxArea = 0;
	for (int i = 0; i < contours.size(); i++)
	{
		int area = contourArea(contours[i]);
		if (area > 1000)
		{
			float peri = arcLength(contours[i], true);
			approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);

			if (conPoly[i].size() == 4 && area > maxArea)
			{
				maxArea = area;
				contourMax = conPoly[i];

				//在原图像上显示轮廓
				//drawContours(imgOri, contours, i, Scalar(255, 0, 255), 2);
			}
		}
	}

	return contourMax;
}

//绘制点集
void drawPoints(Mat imgOri, vector<Point> points, Scalar color)
{
	for (int i = 0; i < points.size(); i++)
	{
		circle(imgOri, points[i], 10, color, FILLED);
		putText(imgOri, to_string(i), points[i], FONT_HERSHEY_PLAIN, 5, color, 5);
	}
}

//文档的四个边界点排序：左上0 右上1 左下2 右下3
vector<Point> pointsReorder(vector<Point> points)
{
	vector<Point> newPoints;
	vector<int> sumPoints, subPoints;

	for (Point point : points)
	{
		sumPoints.push_back(point.x + point.y);
		subPoints.push_back(point.x - point.y);
	}

	//min_element: 返回指向最小元素的迭代器
	newPoints.push_back(points[min_element(sumPoints.begin(), sumPoints.end()) - sumPoints.begin()]); //坐标之和最小的点（直观感觉：最靠近原点）
	newPoints.push_back(points[max_element(subPoints.begin(), subPoints.end()) - subPoints.begin()]); //坐标之差(x-y)最大的点（直观感觉：靠近x轴远处）
	newPoints.push_back(points[min_element(subPoints.begin(), subPoints.end()) - subPoints.begin()]); //坐标之差(x-y)最小的点（直观感觉：靠近y轴远处）
	newPoints.push_back(points[max_element(sumPoints.begin(), sumPoints.end()) - sumPoints.begin()]); //坐标之和最大的点（直观感觉：最远离原点）

	return newPoints;
}

//获取扫描后的文档
Mat getWarpDoc(Mat img, vector<Point> points, float width = 0, float height = 0)
{	
	if (width == 0 || height == 0)
	{
		width = (sqrt(pow(points[0].x - points[1].x, 2) + pow(points[0].y - points[1].y, 2)) +
			sqrt(pow(points[2].x - points[3].x, 2) + pow(points[2].y - points[3].y, 2))) / 2.0;
		height = (sqrt(pow(points[0].x - points[2].x, 2) + pow(points[0].y - points[2].y, 2)) +
			sqrt(pow(points[1].x - points[3].x, 2) + pow(points[1].y - points[3].y, 2))) / 2.0;
	}

	Mat imgWarp;
	Point2f src[4] = { points[0],points[1],points[2],points[3] };
	Point2f dst[4] = { {0, 0},{width, 0},{0, height},{width, height} };

	Mat matrix = getPerspectiveTransform(src, dst);
	warpPerspective(img, imgWarp, matrix, Size(width, height));

	return imgWarp;
}

//文档扫描
void main()
{
	string path = "../Resources/paper.jpg";
	Mat imgOriginal, imgGray, imgCanny;
	imgOriginal = imread(path);
	//将图像缩放便于处理 当程序调试完成后可取消缩放
	//resize(imgOriginal, imgOriginal, Size(), 0.5, 0.5);

	//图像预处理
	Mat imgPrepro = preProcessing(imgOriginal);
	//获取文档四个点的坐标
	vector<Point> initialPoints = getMaxContour(imgPrepro, imgOriginal);
	//重新排序
	vector<Point> docPoints = pointsReorder(initialPoints);
	//获取扫描结果
	float width = 420;
	float height = 596;
	Mat imgWarp = getWarpDoc(imgOriginal, docPoints, width, height);
	drawPoints(imgOriginal, docPoints, Scalar(0, 0, 255));

	//裁剪
	int cropVal = 5; //各边界需要裁剪的像素值
	Rect roi(cropVal, cropVal, width - 2 * cropVal, height - 2 * cropVal);
	Mat imgCrop = imgWarp(roi);

	imshow("image", imgOriginal);
	imshow("image preprocessed", imgPrepro);
	imshow("image warp", imgWarp);
	imshow("image crop", imgCrop);
	waitKey(0);
}
	