#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace std;
using namespace cv;

void main()
{
	string path = "../Resources/test.png";
	Mat img = imread(path);
	Mat imgResize;

	//打印size
	//cout << img.size() << endl;

	//调整图片大小
	//resize(img, imgResize, Size(640, 180));
	//按比例缩放
	resize(img, imgResize, Size(), 0.5, 0.5);

	//裁剪
	Rect roi(100, 100, 300, 250);
	Mat imgCrop = img(roi);

	imshow("image", img);
	imshow("image resize", imgResize);
	imshow("image crop", imgCrop);
	waitKey(0);
}
