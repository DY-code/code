#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

//ÿ֧�ʶ�Ӧ��ɫ��
//��ȡ�õ���ɫ����ֵ ʹ��colorPicker.cpp�еĳ���
//hmin, smin, vmin, hmax, smax, vmax
vector<vector<int>> colorBlocks{ {156, 134, 193, 179, 255, 255}  //red
								};
//��׼��ɫֵ
vector<Scalar> colorVals{ {255, 0, 255}, //purple
								{0, 255, 0} }; //green

//����mask��ȡ�ʼ�����
Point getPenPoint(Mat img, Mat mask)
{
	vector<vector<Point>> contours; //�洢��ȡ������
	vector<Vec4i> hierarchy;

	findContours(mask, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
	vector<vector<Point>> conPoly(contours.size()); //�洢�ƽ�����
	vector<Rect> boundRect(contours.size()); //�洢�ƽ������ľ��ο�

	Point penPoint(0, 0); //�ʼ�����
	for (int i = 0; i < contours.size(); i++) //����ÿ������
	{
		int area = contourArea(contours[i]); //�������

		//�������ɸѡ����
		if (area > 10)
		{
			//���������ܳ�
			float peri = arcLength(contours[i], true);
			//��ָ�����ȱƽ����� ���������conPoly[i]
			approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);

			//cout << conPoly[i].size() << endl;
			//��ȡ�����ľ��ο�
			boundRect[i] = boundingRect(conPoly[i]);
			//��ȡ���ο򶥲����ĵ�����
			penPoint.x = boundRect[i].x + boundRect[i].width / 2;
			penPoint.y = boundRect[i].y;

			drawContours(img, conPoly, i, Scalar(255, 0, 255), 2);
			rectangle(img, boundRect[i].tl(), boundRect[i].br(), Scalar(0, 255, 0), 2);

			//�õ�һ������Ҫ������꼴����
			return penPoint;
		}
	}

	return penPoint;
}

//��ȡÿ֧�ʵıʼ����� ׷�ӵ����еĵ㼯��
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

		//����mask��ȡ�ʼ�����
		Point penPoint = getPenPoint(img, mask);
		//δ�ɹ��ҵ��ʼ�ʱ����(0, 0)
		if (penPoint.x != 0 && penPoint.y != 0)
			oldPoints.push_back({ penPoint.x, penPoint.y, i });
	}
}

//���Ƶ㼯
void draw_dotSets(Mat img, const vector<vector<int>>& points, vector<Scalar> colorVals)
{
	for (int i = 0; i < points.size(); i++)
	{
		circle(img, Point(points[i][0], points[i][1]), 10, colorVals[points[i][2]], FILLED);
	}
}

void main()
{
	/*����ͷ webcam*/
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
