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
	//string path = "../Resources/test.png";
	string path = "../Resources/my_images/image1.jpg";
	Mat img = imread(path);

	CascadeClassifier faceCascade;
	//���ط�����
	faceCascade.load("../Resources/haarcascade_frontalface_default.xml");
	//����Ƿ�ɹ�����
	if (faceCascade.empty())
		cout << "xml file not loaded." << endl;

	vector<Rect> faces;
	//Ŀ���� ����rectangle list
	faceCascade.detectMultiScale(img, faces, 1.1, 10);
	for (int i = 0; i < faces.size(); i++)
	{
		//Rect���ȡ���ϽǺ����½����꣺tl-topleft br-bottomright 
		rectangle(img, faces[i].tl(), faces[i].br(), Scalar(255, 0, 255), 3);
	}

	cout << img.size() << endl;

	resize(img, img, Size(), 0.5, 0.5);
	imshow("image", img);
	waitKey(0);
}
