% 演示使用matlab自带函数 shortestpath() 求解无向图最短路径
clear, clc, close all;

%% 测试数据
rng('shuffle');
A = round(rand(10, 10) / 1.5);
for i = 1 : 10
    for j = i : 10
        A(i, j) = 0;
    end
end
A = A + A';

%% 
% 利用邻接矩阵得到无向图
G = graph(A); 
% 绘制无向图
myplot = plot(G, 'linewidth', 2);
% 求解最短路径，点1到点10
path = shortestpath(G, 1, 10);

% 高亮显示最短路径
highlight(myplot, path, 'EdgeColor', 'r');