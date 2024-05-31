clc,clear, close all
sj0 = load('data12_1.txt');
x = sj0(:, 1:2:8); x = x(:);     % 转换为列向量
y = sj0(:, 2:2:8); y = y(:);
sj = [x y]; d1 = [70, 40];       % 基地坐标
xy = [d1; sj; d1];          % xy: 102个坐标序列
sj = xy*pi/180;  %单位化成弧度（经纬度坐标单位为度）
d = zeros(102); %距离矩阵d的初始值  zeros(102)为方阵

%%
% 计算两个坐标点之间的距离
for i = 1:101
    for j = i+1:102
        d(i,j) = 6370 *acos(cos(sj(i,1)-sj(j,1))*cos(sj(i,2))*...
            cos(sj(j,2))+sin(sj(i,2))*sin(sj(j,2)));
    end
end

%% 模拟退火算法 得到初始种群 大小为w
d = d + d'; % 填补距离矩阵左下部分的空白
w = 50; g = 100; %w为种群的个数，g为进化的代数
for k = 1:w  %通过改良圈算法选取初始种群
    c = randperm(100); %产生1，...，100的一个全排列
    c1 = [1, c+1, 102]; %生成初始解 存储102个目标对应的序号 先后顺序代表路径顺序
    for t = 1:102 %该层循环是修改圈
        flag = 0; %修改圈退出标志
        for m = 1:100
            for n = m + 2:101
                if d(c1(m), c1(n)) + d(c1(m+1), c1(n+1)) < ...        % 比较变换前后的距离变化情况
                        d(c1(m), c1(m+1)) + d(c1(n), c1(n+1))       % 若变换后距离减小则接受新解
                    %修改圈
                    c1(m+1:n) = c1(n:-1:m+1);  % 逆序
                    flag = 1;
                end
            end
        end
        if flag == 0 % 修改循环结束后序列c1未发生改变
            J(k, c1) = 1:102; % 目标从1~102，记录其排列的先后顺序
            break %记录下较好的解并退出当前层循环（修改圈）
        end
    end
end
% 至此，J的每一行代表初始种群的一个个体，其排列顺序代表点（侦查目标）的序号
% 其值代表点（侦查目标）在当前路径中的位置

J(:, 1) = 0; % 每行第一个元素置为零
J = J / 102; %把整数序列转换成[0,1]区间上的实数，即转换成染色体编码
% 至此，J的每一行代表初始种群的一个个体的染色体编码，若对J从小到大排序，
% 得到的结果的排列顺序代表当前路径顺序，排序
% 得到的索引向量的值代表对应点的索引

%%  遗传算法
for k = 1 : g  %该层循环进行遗传算法的操作 共迭代g次
    A = J; %交配产生子代A的初始染色体
    c = randperm(w); %产生下面交叉操作的染色体对
    for i = 1:2:w  % 相邻两对染色体进行交叉互换
        F = 2 + floor(100*rand(1)); %产生交叉操作的地址 F为范围: 2 ~ 101内的任意值
        temp = A(c(i), [F:102]); %中间变量的保存值 保存待交换的染色体片段
        A(c(i), [F:102]) = A(c(i+1), [F:102]); %交叉操作
        A(c(i+1), F:102) = temp;
    end

    by=[];  %为了防止下面产生空地址，这里先初始化
    while isempty(by)
        by = find(rand(1,w) < 0.1); %产生变异操作的地址 选择产生变异的染色体
    end

    B = A(by, :); %提取产生变异操作的初始染色体
    % 对选择的染色体进行变异
    for j = 1:length(by)
        bw = sort(2+floor(100*rand(1,3)));  %产生变异操作的3个地址
        B(j,:) = B(j, [1:bw(1)-1, bw(2)+1:bw(3), bw(1):bw(2), bw(3)+1:102]); %染色体片段交换位置
    end

    G = [J; A; B]; %父代和子代种群合在一起
    % sort(G, 2) 对矩阵G中每一行进行排序
    % ind1中每行代表一个个体，其排列顺序代表路径顺序，其值代表对应点的序号
    [SG, ind1] = sort(G, 2); %把染色体翻译成1，...,102的序列ind1 对矩阵G的每行进行排序
    num = size(G, 1); % 获取当前种群个体总数
    long = zeros(1, num); %路径长度的初始值 共得到num条路径
    for j = 1:num
        for i = 1:101
            long(j) = long(j) + d(ind1(j, i), ind1(j, i+1)); %计算每条路径长度
        end
    end
    [slong, ind2] = sort(long); %对路径长度按照从小到大排序
    J = G(ind2(1:w),:); %精选前w个较短的路径对应的染色体
end

%%
path = ind1(ind2(1), :);
flong = slong(1);  %解的路径及路径长度（最短路径）
xx = xy(path, 1);
yy = xy(path, 2);
plot(xx, yy, '-o') %画出路径
