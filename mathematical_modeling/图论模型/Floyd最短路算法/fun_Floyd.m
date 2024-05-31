%% Function:输出网络图的最短距离矩阵和路由矩阵，指定两结点间的最短距离及其路径
function [D, P, dis, path] = fun_Floyd(W, start, stop) %start为指定起始结点，stop为指定终止结点
D = W; %最短距离矩阵赋初值
n = length(D); %n为结点个数
P = zeros(n, n); %路由矩阵赋初值

for i = 1:n
    for j = 1:n
        P(i, j) = j;
    end
end

%核心代码
for k = 1:n
    for i = 1:n
        for j = 1:n
            if D(i, k) + D(k, j) < D(i, j)
                D(i, j) = D(i, k) + D(k, j);   % 更新距离
                P(i, j) = P(i, k);  %更新中间点
            end
        end
    end
end
% 求出起点到终点的最短距离及对应的路径
[dis, path] = fun_get_path(start, stop);

% 绘图
fun_plot(W, path);

    % 根据最短距离矩阵和路由矩阵求出指定两点的最短路径
    function [dis, path] = fun_get_path(start, stop)
        dis = D(start, stop); %指定两结点间的最短距离
        path(1) = start;
        i = 1;
        %指定两结点之间的最短路径
        while P(path(i), stop) ~= stop
            path(i + 1) = P(path(i), stop);
            i = i + 1;
        end
        path(i+1) = stop;
    end
    
    % 求各点到指定点的最短距离及路径
    % Distances: 最短距离
    % Paths: 最短路径
    % Connection: 最短路径对应点的连接情况，便于绘图
    function [Distances, Paths] = fun_get_paths(dest)
        N = size(D, 1);
        con = [];
        
        for ii = 1 : N
            if ii ~= dest
                [Distances(ii), Paths{ii}] = fun_get_path(ii, dest);

%                 for j = 1 : size(Paths{ii}, 2) - 1
%                     con = [con; Paths{ii}(j), Paths{ii}(j+1)];
%                 end
            end
        end
        Distances(dest, :) = 0;
        
%         % 去除重复的连接
%         Cons = cell(N, 1);
%         for ii = 1 : size(con, 1)
%             % 无重复连接
%             if size(find(Cons{con(ii, 1)} == con(ii, 2)), 2) == 0
%                 Cons{con(ii, 1)} = [Cons{con(ii, 1)}, con(ii, 2)];
%             end
%         end
%         Connection = [];
%         for ii = 1 : N
%             for j = 1 : size(Cons{N}, 2)
%                 Connection = [Connection; ii, Cons{N}(j)];
%             end
%         end
    end

end

%% 绘图函数
% W: 邻接矩阵
% path: 需高亮显示的路径
% connection: 最短路径对应点的连接情况
function fun_plot(W, path)
    N = size(W, 1);
    % 两点之间无连接用0表示，对角元素为零
    for i = 1 : N
        for j = 1 : N
            if i == j
                W(i, j) = 0;
            elseif W(i, j) == inf
                   W(i, j) = 0;
            end
        end
    end

    names = {};
    for i = 1 : N
        names{i} = strcat('v', int2str(i));
    end

    G = graph(W);
    myplot = plot(G, 'NodeLabel', names, 'NodeFontSize', 10, 'NodeColor', 'b', 'NodeLabelColor', 'b', ...
        'LineWidth', 2, 'EdgeLabel', G.Edges.Weight, 'EdgeFontSize', 10);
    highlight(myplot, path, 'EdgeColor', 'r');

%     figure;
%     g = digraph(connection(:, 1), connection(:, 2), weight);
%     plot(g, 'EdgeLabel', g.Edges.Weight);
end
    

















