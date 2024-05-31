% dijkstra求最短路径算法
clear, clc, close all;

%% 测试数据
rng(1);
N = 20;
A = round(rand(N, N) * 10) - 8;
for i = 1 : size(A, 1)
    for j = i : size(A, 1)
        A(i, j) = 0;
    end
end
A = A + A';
for i = 1 : size(A, 1)
    for j = 1 : size(A, 1)
        if i ~= j && A(i, j) <= 0
            A(i, j) = inf;
        end
    end
end
A

%% 求解并显示最短路径
start = 1;
dest = 4;
D = A;
% 绘图时以0表示无连接
D(D == inf) = 0;
G = graph(D);
myplot = plot(G, 'EdgeLabel', G.Edges.Weight, 'LineWidth', 2, ...
    'EdgeFontSize', 10, 'NodeFontSize', 10, 'NodeColor', 'r', 'NodelabelColor', 'r'); 
hold on;
[dist, path, connection, distance] = fun_dijkstra(A, start, dest);
% 高亮显示最短路径
highlight(myplot, path, 'Edgecolor', 'r');
title('最短路径');

%% 显示各点到终点的最短路径
connection(:, dest) = [];
weight = []; % 获得连接点之间的距离
for i = 1 : size(connection, 2)
    weight(i) = A(connection(1, i), connection(2, i));
end

g = digraph(connection(1, :)', connection(2, :)', weight);
figure;
plot(g, 'EdgeLabel', g.Edges.Weight);
title('各点到终点的最短距离');


















