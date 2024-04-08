#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/objdetect.hpp>
#include <iostream>

using namespace cv;
using namespace std;

//车牌识别
void main()
{
	VideoCapture cap(0);
	Mat img;

	CascadeClassifier plateCascade;
	//加载分类器
	plateCascade.load("../Resources/haarcascade_russian_plate_number.xml");
	//检查是否成功加载
	if (plateCascade.empty())
		cout << "xml file not loaded." << endl;

	vector<Rect> plates;
	while (true)
	{
		cap.read(img);
		//目标检测 返回rectangle list
		plateCascade.detectMultiScale(img, plates, 1.1, 10);
		for (int i = 0; i < plates.size(); i++)
		{
			static int num = 0;

			Mat imgCrop = img(plates[i]);
			//imshow(to_string(i), imgCrop);
			//保存车牌图片
			imwrite("../Resources/Plates/" + to_string(num++) + ".png", imgCrop);

			//Rect类获取左上角和右下角坐标：tl-topleft br-bottomright 
			rectangle(img, plates[i].tl(), plates[i].br(), Scalar(255, 0, 255), 3);
		}


		imshow("image", img);
		waitKey(1);
	}
}
