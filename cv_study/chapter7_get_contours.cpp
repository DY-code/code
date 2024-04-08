#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace std;
using namespace cv;

//��ȡ����ʾ����
void getContours(Mat imgDilation, Mat img)
{
	vector<vector<Point>> contours;
	//Vec4i: ��4��int��vector
	vector<Vec4i> hierarchy;

	//���ݶ�ֵ��ͼ���ȡ����
	//image = imgDilation: ����ͼ�� ��Ϊ��ֵ��ͼ����
	//contours: ��⵽������
	//mode = RETR_EXTERNAL: ��������ⲿ������
	//method = CHAIN_APPROX_SIMPLE: �������ƺ�ѹ��
	findContours(imgDilation, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
	//��������
	//image = img: �����Ƶ�Ŀ��ͼ��
	//contours: �������������
	//contourIdx = -1��������������
	//color = Scalar(255, 0, 255): ������ɫ
	//thickness = 2: ������ϸ
	//drawContours(img, contours, -1, Scalar(255, 0, 255), 2);

	//�ƽ����� conPoly��С��contoursһ��
	vector<vector<Point>> conPoly(contours.size());
	vector<Rect> boundRect(contours.size());
	string objectType;
	for (int i = 0; i < contours.size(); i++)
	{
		double area = contourArea(contours[i]);
		//cout << area << endl;

		if (area > 1000) //���˵���Χ�����С������
		{
			//closed = true ����պ����ߵ��ܳ�
			float peri = arcLength(contours[i], true);
			//��ָ�����ȱƽ�����
			//approxCurve = conPoly[i]���ƽ��Ľ��
			//epsilon = 0.02 * peri: �ƽ�����
			approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);

			//ÿ���ƽ������Ľǵ�����
			cout << conPoly[i].size() << endl;
			//��ȡPoint set����С�߽���ο� ����Rect����
			boundRect[i] = boundingRect(conPoly[i]);
			//ÿ���ƽ������Ľǵ�����
			int objCor = (int)conPoly[i].size();

			if (objCor == 3) objectType = "tri";
			else if (objCor == 4) 
			{
				//�߿��
				float aspRatio = (float)boundRect[i].width / (float)boundRect[i].height;
				cout << aspRatio << endl;
				if (aspRatio > 0.95 && aspRatio < 1.05) //������
					objectType = "square";
				else //����
					objectType = "rect";
			}
			else if (objCor > 4) objectType = "circle";
			else objectType = "unknown";

			//���Ʊƽ�����
			drawContours(img, conPoly, i, Scalar(255, 0, 255), 2);
			//���ƾ��ο�
			rectangle(img, boundRect[i].tl(), boundRect[i].br(), Scalar(0, 255, 0), 5);
			//��ʾ��ǩ
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
	//��ȡ�ṹԪ��
	//shape = MORPH_RECT: �����ں���״Ϊ����
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
