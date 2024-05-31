function [dist, path, connection, Distance] = fun_dijkstra(A, start, dest)
% 功能：利用dijkstra算法计算两点间的最短路径
% dist：起点与终点之间的最短距离值
% path：最短路径索引，一共两行，第一行的值依次为各顶点编号
% 第二行的值为与第一行顶点相连的顶点编号
% connection: 最短路径下个点之间的连接关系
% Distance：最短路径下的距离值，一共两行，第一行的值为各顶点编号
% 第二行的值为对应顶点到终点的最小距离值
% A：邻接矩阵，存储各顶点之间的距离值，两点之间无连接用inf表示
% 是一个大小为顶点个数的方阵，对角线元素为0
% strat：起点编号
% dest：终点编号

%% 测试数据
% clear, clc, close all;
% % 邻接矩阵，存储各顶点之间的距离值
% A =[0,12,inf,inf,inf,16,14;12,0,10,inf,inf,7,inf;inf,10,0,3,5,6,inf;inf,inf,3,0,4,inf,inf;inf,inf,5,4,0,2,8;16,7,6,inf,2,0,9;14,inf,inf,inf,8,9,0];
% start = 1; % 起点编号
% dest = 4; % 终点编号

%% 
 
% 初始化操作
p = size(A, 1);        %计算顶点数目 

S(1) = dest;          %初始化集合S，已加入到路径中的顶点编号
U = 1:p;              %初始化集合U，未加入到路径中的顶点编号
U(dest) = [];         %删除终点编号

Distance = zeros(2,p);  %初始化所有顶点到终点dest的距离
Distance(1, :) = 1 : p;    %重赋值第一行为各顶点编号
Distance(2, 1:p) = A(dest, 1:p);  %重赋值第二行为邻接矩阵中各顶点到终点的距离
new_Distance = Distance;

D = Distance;            %初始化U中所有顶点到终点dest的距离
D(:, dest) = [];          %删除U中终点编号到终点编号的距离
connection = zeros(2,p);  %初始化所求最短路径的连接关系
connection(1, :) = 1:p;    %重赋值第一行为各顶点编号
connection(2, Distance(2, :) ~= inf) = dest;  %距离值不为无穷大时，将两顶点相连
 
% 寻找最短路径
while ~isempty(U)  % U中元素不为空，继续循环
    % D为未确定最短路径的点的集合，存储到终点的距离
    index = find(D(2, :) == min(D(2, :)), 1);  %剩余顶点中距离最小值的第一个索引
    k = D(1, index);   %剩余顶点中距离终点最近的顶点编号
    
    %计算距离 new_Distance为中间变量
    new_Distance(2, :) = A(k, 1:p) + Distance(2, k); %计算各顶点先通过结点k，再从k到达终点的所有点距离值
    D = min(Distance, new_Distance);  %与原来的距离值比较，取最小值  
   
    %更新最短路径的连接关系
    connection(2, D(2, :) ~= Distance(2, :)) = k;  %出现新的最小值，更改连接关系，连接到结点k上 
    
    %更新距离
    Distance = D;  %更新距离表为所有点到终点的最小值
    D(:, S) = [];   %删除已加入到S中的顶点

    %更新顶点
    S = [S, k];     %将顶点k添加到S中
    U(U == k) = [];  %从U中删除顶点k  
end
dist = Distance(2, start);  %取出指定起点到终点的距离值

%% 根据connection中的信息还原最短路径，start -> dest
path = []; 
next = start;
while next ~= dest
    path = [path, next];
    next = connection(2, next);
end
path = [path, dest];

%% 输出结果
fprintf('找到的最短路径为：');
for i = 1 : size(path, 2) - 1
    fprintf('%d-->', path(i));  %打印当前点编号
end
fprintf('%d\n', dest);
fprintf('最短路径对应的距离为：%d\n', dist);

end
 