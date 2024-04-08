#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

//每支笔对应的色块
//提取得到的色块阈值 使用colorPicker.cpp中的程序
//hmin, smin, vmin, hmax, smax, vmax
vector<vector<int>> colorBlocks{ {156, 134, 193, 179, 255, 255}  //red
								};
//标准颜色值
vector<Scalar> colorVals{ {255, 0, 255}, //purple
								{0, 255, 0} }; //green

//根据mask获取笔尖坐标
Point getPenPoint(Mat img, Mat mask)
{
	vector<vector<Point>> contours; //存储获取的轮廓
	vector<Vec4i> hierarchy;

	findContours(mask, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
	vector<vector<Point>> conPoly(contours.size()); //存储逼近轮廓
	vector<Rect> boundRect(contours.size()); //存储逼近轮廓的矩形框

	Point penPoint(0, 0); //笔尖坐标
	for (int i = 0; i < contours.size(); i++) //遍历每个轮廓
	{
		int area = contourArea(contours[i]); //计算面积

		//根据面积筛选轮廓
		if (area > 10)
		{
			//计算轮廓周长
			float peri = arcLength(contours[i], true);
			//以指定精度逼近轮廓 结果返回至conPoly[i]
			approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);

			//cout << conPoly[i].size() << endl;
			//获取轮廓的矩形框
			boundRect[i] = boundingRect(conPoly[i]);
			//获取矩形框顶部中心的坐标
			penPoint.x = boundRect[i].x + boundRect[i].width / 2;
			penPoint.y = boundRect[i].y;

			drawContours(img, conPoly, i, Scalar(255, 0, 255), 2);
			rectangle(img, boundRect[i].tl(), boundRect[i].br(), Scalar(0, 255, 0), 2);

			//得到一个符合要求的坐标即返回
			return penPoint;
		}
	}

	return penPoint;
}

//获取每支笔的笔尖坐标 追加到已有的点集中
void findPenPoints(Mat img, vector<vector<int>> colorBlocks, vector<vector<int>>& oldPoints)
{
	Mat imgHSV;
	cvtColor(img, imgHSV, COLOR_BGR2HSV);

	for (int i = 0; i < colorBlocks.size(); i++)
	{
		Scalar lower(colorBlocks[i][0], colorBlocks[i][1], colorBlocks[i][2]);
		Scalar upper(colorBlocks[i][3], colorBlocks[i][4], colorBlocks[i][5]);

		Mat mask;
		inRange(imgHSV, lower, upper, mask);
		imshow(to_string(i), mask);

		//根据mask获取笔尖坐标
		Point penPoint = getPenPoint(img, mask);
		//未成功找到笔尖时返回(0, 0)
		if (penPoint.x != 0 && penPoint.y != 0)
			oldPoints.push_back({ penPoint.x, penPoint.y, i });
	}
}

//绘制点集
void draw_dotSets(Mat img, const vector<vector<int>>& points, vector<Scalar> colorVals)
{
	for (int i = 0; i < points.size(); i++)
	{
		circle(img, Point(points[i][0], points[i][1]), 10, colorVals[points[i][2]], FILLED);
	}
}

void main()
{
	/*摄像头 webcam*/
	VideoCapture cap(0);
	Mat img;

	vector<vector<int>> penPoints;
	while (true)
	{
		cap.read(img);
		
		findPenPoints(img, colorBlocks, penPoints);
		draw_dotSets(img, penPoints, colorVals);

		imshow("image", img);
		waitKey(1);
	}
}
