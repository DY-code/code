% function [IDX, isnoise] = DBSCAN(X, epsilon, MinPts)    % DBSCAN聚类函数
clear, clc, close all;
X = randn(250, 2);
X = [X; randn(250, 2) - 3];
X = [X; randn(250, 2) - 6];
X = [X; randn(250, 2) - 9];
epsilon = 0.5;
MinPts = 10;


C = 0;                       % 统计簇类个数，初始化为0

n = size(X,1);               % 把矩阵X的行数数赋值给n，即一共有n个点
IDX = zeros(n, 1);            % 定义一个n行1列的矩阵

D = pdist2(X, X);             % 计算距离矩阵

visited = false(n,1);        % 创建一维的标记数组，全部初始化为false，代表还未被访问
isnoise = false(n,1);        % 创建一维的异常点数组，全部初始化为false，代表该点不是异常点

for i = 1:n                  % 遍历1~n个所有的点
    if ~visited(i)         % 未被访问，则执行下列代码
        visited(i) = true;   % 标记为true，已经访问

        neighbors = RegionQuery(i, D, epsilon);     % 查询周围点中距离小于等于epsilon的个数
        if numel(neighbors) < MinPts    % 如果小于MinPts
            % X(i,:) is NOISE
            isnoise(i) = true;          % 该点是异常点
        else              % 如果大于MinPts, 且距离大于epsilon
            C = C+1;        % 该点又是新的簇类中心点,簇类个数+1
            ExpandCluster(i, neighbors, C, visited, D, IDX, epsilon, MinPts);    % 如果是新的簇类中心，执行下面的函数
        end
    end

end                    % 循环完n个点，跳出循环

% 判断该点周围的点是否直接密度可达
function ExpandCluster(i, neighbors, C, visited, D, IDX, epsilon, MinPts)   
% i: 核心点的索引
% neighbors: 核心点对应的边界点
IDX(i)=C;                            % 将第i个C簇类记录到IDX(i)中

k = 1;
while true                           % 一直循环
    j = neighbors(k);                % 找到距离小于epsilon的第一个直接密度可达点的索引

    if ~visited(j)                   % 如果没有被访问
        visited(j) = true;             % 标记为已访问
        neighbors2 = RegionQuery(j, D ,epsilon);   % 查询周围点中距离小于epsilon的个数
        if numel(neighbors2) >= MinPts % 如果周围点的个数大于等于Minpts，代表该点直接密度可达
            neighbors = [neighbors, neighbors2];   % 将该点包含着同一个簇类当中
        end
    end                              % 退出循环
    if IDX(j) == 0                     % 如果还没形成任何簇类
        IDX(j) = C;                    % 点j属于第C个簇类
    end                              % 退出循坏

    k = k + 1;                       % k+1,继续遍历下一个直接密度可达的点
    if k > numel(neighbors)          % 如果已经遍历完所有直接密度可达的点，则退出循环
        break;
    end
end
end                                      % 退出循环

% 查询周围点中距离小于等于epsilon的个数，返回值为点在D中的索引
function Neighbors = RegionQuery(i, D, epsilon)        
Neighbors = find(D(i,:) <= epsilon);
end
% end

