#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

//Ԥ����
Mat preProcessing(Mat img)
{
	Mat imgGray, imgBlur, imgCanny, imgDilation;
	cvtColor(img, imgGray, COLOR_BGR2GRAY);

	GaussianBlur(imgGray, imgBlur, Size(3, 3), 3, 0);
	Canny(imgBlur, imgCanny, 25, 75);
	//����
	dilate(imgCanny, imgDilation, getStructuringElement(MORPH_RECT, Size(3, 3)));

	return imgDilation;
}

//��ȡ�������
vector<Point> getMaxContour(Mat imgPrepro, Mat imgOri)
{
	vector<vector<Point>> contours;
	vector<Vec4i> hierarchy;

	findContours(imgPrepro, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
	vector<vector<Point>> conPoly(contours.size());
	vector<Rect> boundRect(contours.size());

	//�������ģ����������ֵ
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

				//��ԭͼ������ʾ����
				//drawContours(imgOri, contours, i, Scalar(255, 0, 255), 2);
			}
		}
	}

	return contourMax;
}

//���Ƶ㼯
void drawPoints(Mat imgOri, vector<Point> points, Scalar color)
{
	for (int i = 0; i < points.size(); i++)
	{
		circle(imgOri, points[i], 10, color, FILLED);
		putText(imgOri, to_string(i), points[i], FONT_HERSHEY_PLAIN, 5, color, 5);
	}
}

//�ĵ����ĸ��߽����������0 ����1 ����2 ����3
vector<Point> pointsReorder(vector<Point> points)
{
	vector<Point> newPoints;
	vector<int> sumPoints, subPoints;

	for (Point point : points)
	{
		sumPoints.push_back(point.x + point.y);
		subPoints.push_back(point.x - point.y);
	}

	//min_element: ����ָ����СԪ�صĵ�����
	newPoints.push_back(points[min_element(sumPoints.begin(), sumPoints.end()) - sumPoints.begin()]); //����֮����С�ĵ㣨ֱ�۸о������ԭ�㣩
	newPoints.push_back(points[max_element(subPoints.begin(), subPoints.end()) - subPoints.begin()]); //����֮��(x-y)���ĵ㣨ֱ�۸о�������x��Զ����
	newPoints.push_back(points[min_element(subPoints.begin(), subPoints.end()) - subPoints.begin()]); //����֮��(x-y)��С�ĵ㣨ֱ�۸о�������y��Զ����
	newPoints.push_back(points[max_element(sumPoints.begin(), sumPoints.end()) - sumPoints.begin()]); //����֮�����ĵ㣨ֱ�۸о�����Զ��ԭ�㣩

	return newPoints;
}

//��ȡɨ�����ĵ�
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

//�ĵ�ɨ��
void main()
{
	string path = "../Resources/paper.jpg";
	Mat imgOriginal, imgGray, imgCanny;
	imgOriginal = imread(path);
	//��ͼ�����ű��ڴ��� �����������ɺ��ȡ������
	//resize(imgOriginal, imgOriginal, Size(), 0.5, 0.5);

	//ͼ��Ԥ����
	Mat imgPrepro = preProcessing(imgOriginal);
	//��ȡ�ĵ��ĸ��������
	vector<Point> initialPoints = getMaxContour(imgPrepro, imgOriginal);
	//��������
	vector<Point> docPoints = pointsReorder(initialPoints);
	//��ȡɨ����
	float width = 420;
	float height = 596;
	Mat imgWarp = getWarpDoc(imgOriginal, docPoints, width, height);
	drawPoints(imgOriginal, docPoints, Scalar(0, 0, 255));

	//�ü�
	int cropVal = 5; //���߽���Ҫ�ü�������ֵ
	Rect roi(cropVal, cropVal, width - 2 * cropVal, height - 2 * cropVal);
	Mat imgCrop = imgWarp(roi);

	imshow("image", imgOriginal);
	imshow("image preprocessed", imgPrepro);
	imshow("image warp", imgWarp);
	imshow("image crop", imgCrop);
	waitKey(0);
}
	