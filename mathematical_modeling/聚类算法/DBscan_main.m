clear, clc, close all;
 
%% Load Data            //定义data.mat数据文件加载模块
 
% data=load('mydata');    % 数据读取
% X=data.X;
n = 250;
for i = 1 : 1000
    costheta = randn(1, 2);
    costheta = costheta / sqrt(costheta(1)^2 + costheta(2)^2);
    X(i, :) = costheta * (rand + 5);
    Y(i, :) = costheta * (rand + 10);
    Z(i, :) = costheta * (rand + 1);
%     K(i, :) = [randn * 10, 0];
end
X = [X; Y; Z];
figure;
plot(X(:, 1), X(:, 2), 'k*'); hold on;
plot(Y(:, 1), Y(:, 2), 'k*'); hold on;
plot(Z(:, 1), Z(:, 2), 'k*'); hold on;
axis equal;
 
%% Run DBSCAN Clustering Algorithm    //定义Run运行模块
 
epsilon = 0.7;                          % 邻域半径
MinPts = 20;            % 判定为核心点的最低标准，最低密度
IDX = DBSCAN(X,epsilon,MinPts);         % 传入参数运行
 
%% Plot Results                       % 定义绘图结果模块
 
figure;
PlotClusterinResult(X, IDX);          % 传入参数，绘制图像
title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);