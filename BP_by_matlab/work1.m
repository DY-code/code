% 生成训练数据
clc
clear
close all
x = 0:0.05:3*pi; % 自变量
y=sin(x)+exp(-x); % 因变量
% 配置神经网络
net=feedforwardnet([10,10,10]);% 三个隐含层，每层10个神经元
net.performFcn='mse';% 损失函数为均方误差
net.divideFcn='divideind';% 训练集、验证集和测试集的分割方式
net.divideMode='sample';% 样本分割模式
net.divideParam.trainInd=1:round(length(x)*0.8);% 训练集的样本下标
net.divideParam.valInd=round(length(x)*0.7)+1:round(length(x)*0.85);% 验证集的样本下标
net.divideParam.testInd=round(length(x)*0.85)+1:length(x);% 测试集的样本下标
net.trainParam.epochs=1000;% 迭代次数
net.trainParam.lr=0.0001;% 学习率
net.trainParam.goal=1e-3;% 网络误差
% 训练神经网络
[net,tr]=train(net,x,y);
% 绘制损失函数曲线
plotperform(tr);
% 绘制拟合曲线和期望波形的图像
y_pred=net(x);
y_expected=sin(x)+exp(-x);
plot(x,y_pred,'b-',x,y_expected,'r--');
xlabel('x');
ylabel('y');
legend('BP Neural Network Fitting','Expected waveform');