#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/objdetect.hpp>
#include <iostream>

using namespace cv;
using namespace std;

//����ʶ��
void main()
{
	VideoCapture cap(0);
	Mat img;

	CascadeClassifier plateCascade;
	//���ط�����
	plateCascade.load("../Resources/haarcascade_russian_plate_number.xml");
	//����Ƿ�ɹ�����
	if (plateCascade.empty())
		cout << "xml file not loaded." << endl;

	vector<Rect> plates;
	while (true)
	{
		cap.read(img);
		//Ŀ���� ����rectangle list
		plateCascade.detectMultiScale(img, plates, 1.1, 10);
		for (int i = 0; i < plates.size(); i++)
		{
			static int num = 0;

			Mat imgCrop = img(plates[i]);
			//imshow(to_string(i), imgCrop);
			//���泵��ͼƬ
			imwrite("../Resources/Plates/" + to_string(num++) + ".png", imgCrop);

			//Rect���ȡ���ϽǺ����½����꣺tl-topleft br-bottomright 
			rectangle(img, plates[i].tl(), plates[i].br(), Scalar(255, 0, 255), 3);
		}


		imshow("image", img);
		waitKey(1);
	}
}
