#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace std;
using namespace cv;

//获取并显示轮廓
void getContours(Mat imgDilation, Mat img)
{
	vector<vector<Point>> contours;
	//Vec4i: 含4个int的vector
	vector<Vec4i> hierarchy;

	//根据二值化图像获取轮廓
	//image = imgDilation: 输入图像 作为二值化图像处理
	//contours: 检测到的轮廓
	//mode = RETR_EXTERNAL: 仅检测最外部的轮廓
	//method = CHAIN_APPROX_SIMPLE: 轮廓近似和压缩
	findContours(imgDilation, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
	//绘制轮廓
	//image = img: 待绘制的目标图像
	//contours: 输入的轮廓数据
	//contourIdx = -1：绘制所有轮廓
	//color = Scalar(255, 0, 255): 轮廓颜色
	//thickness = 2: 轮廓粗细
	//drawContours(img, contours, -1, Scalar(255, 0, 255), 2);

	//逼近轮廓 conPoly大小与contours一致
	vector<vector<Point>> conPoly(contours.size());
	vector<Rect> boundRect(contours.size());
	string objectType;
	for (int i = 0; i < contours.size(); i++)
	{
		double area = contourArea(contours[i]);
		//cout << area << endl;

		if (area > 1000) //过滤掉包围面积较小的轮廓
		{
			//closed = true 计算闭合曲线的周长
			float peri = arcLength(contours[i], true);
			//以指定精度逼近曲线
			//approxCurve = conPoly[i]：逼近的结果
			//epsilon = 0.02 * peri: 逼近精度
			approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);

			//每个逼近轮廓的角点数量
			cout << conPoly[i].size() << endl;
			//获取Point set的最小边界矩形框 返回Rect类型
			boundRect[i] = boundingRect(conPoly[i]);
			//每个逼近轮廓的角点数量
			int objCor = (int)conPoly[i].size();

			if (objCor == 3) objectType = "tri";
			else if (objCor == 4) 
			{
				//高宽比
				float aspRatio = (float)boundRect[i].width / (float)boundRect[i].height;
				cout << aspRatio << endl;
				if (aspRatio > 0.95 && aspRatio < 1.05) //正方形
					objectType = "square";
				else //矩形
					objectType = "rect";
			}
			else if (objCor > 4) objectType = "circle";
			else objectType = "unknown";

			//绘制逼近轮廓
			drawContours(img, conPoly, i, Scalar(255, 0, 255), 2);
			//绘制矩形框
			rectangle(img, boundRect[i].tl(), boundRect[i].br(), Scalar(0, 255, 0), 5);
			//显示标签
			putText(img, objectType, { boundRect[i].x, boundRect[i].y - 5 }, FONT_HERSHEY_PLAIN, 1, Scalar(0, 69, 255), 1);
		}
	}
}

// shape detection
void main()
{
	string path = "../Resources/shapes.png";
	Mat img = imread(path);
	Mat imgGray, imgBlur, imgCanny, imgDilation, imgErode;

	// preprocessing
	cvtColor(img, imgGray, COLOR_BGR2GRAY);
	GaussianBlur(imgGray, imgBlur, Size(3, 3), 3, 0);
	Canny(imgBlur, imgCanny, 25, 75);
	//获取结构元素
	//shape = MORPH_RECT: 设置内核形状为矩形
	Mat kernel = getStructuringElement(MORPH_RECT, Size(3, 3));
	dilate(imgCanny, imgDilation, kernel);

	getContours(imgDilation, img);

	imshow("image", img);
	//imshow("image gray", imgGray);
	//imshow("image blur", imgBlur);
	//imshow("image canny", imgCanny);
	//imshow("image dilation", imgDilation);
	waitKey(0);
}
