%% 模拟退火解决TSP问题(很多地方我直接引用的蒙特卡罗模拟里面的代码)

tic
rng('shuffle')  % 控制随机数的生成，否则每次打开matlab得到的结果都一样
clear, clc;
% 38个城市，最优结果6656
% coord: 38*2
coord = [11003.611100,42102.500000;11108.611100,42373.888900;11133.333300,42885.833300;11155.833300,42712.500000;11183.333300,42933.333300;11297.500000,42853.333300;11310.277800,42929.444400;11416.666700,42983.333300;11423.888900,43000.277800;11438.333300,42057.222200;11461.111100,43252.777800;11485.555600,43187.222200;11503.055600,42855.277800;11511.388900,42106.388900;11522.222200,42841.944400;11569.444400,43136.666700;11583.333300,43150.000000;11595.000000,43148.055600;11600.000000,43150.000000;11690.555600,42686.666700;11715.833300,41836.111100;11751.111100,42814.444400;11770.277800,42651.944400;11785.277800,42884.444400;11822.777800,42673.611100;11846.944400,42660.555600;11963.055600,43290.555600;11973.055600,43026.111100;12058.333300,42195.555600;12149.444400,42477.500000;12286.944400,43355.555600;12300.000000,42433.333300;12355.833300,43156.388900;12363.333300,43189.166700;12372.777800,42711.388900;12386.666700,43334.722200;12421.666700,42895.555600;12645.000000,42973.333300];
n = size(coord,1);  % 城市的数目

figure  % 新建一个图形窗口
plot(coord(:, 1), coord(:, 2), 'o');   % 画出城市的分布散点图
hold on % 等一下要接着在这个图形上画图的

d = zeros(n);   % 初始化两个城市的距离矩阵
for i = 2:n  
    for j = 1:i  
        x_i = coord(i, 1);     y_i = coord(i, 2);  % 城市i的横坐标为x_i，纵坐标为y_i
        x_j = coord(j, 1);     y_j = coord(j, 2);  % 城市j的横坐标为x_j，纵坐标为y_j
        d(i, j) = sqrt((x_i - x_j)^2 + (y_i - y_j)^2);   % 计算城市i和j的距离
    end
end
d = d + d';   % 生成距离矩阵的对称的一面

%% 参数初始化
T0 = 1000;   % 初始温度
T = T0; % 迭代中温度会发生改变，第一次迭代时温度就是T0
maxgen = 1000;  % 最大迭代次数
Lk = 500;  % 每个温度下的迭代次数
alpfa = 0.95;  % 温度衰减系数

%%  随机生成一个初始解
path0 = randperm(n);  % 生成一个1-n的随机打乱的序列作为初始的路径
result0 = calculate_tsp_d(path0, d); % 调用我们自己写的calculate_tsp_d函数计算当前路径的距离

%% 定义一些保存中间过程的量，方便输出结果和画图
min_result = result0;     % 初始化找到的最佳的解对应的距离为result0
RESULT = zeros(maxgen,1); % 记录每一次外层循环结束后找到的min_result (方便画图）

%% 模拟退火过程
for iter = 1 : maxgen  % 外循环, 指定最大迭代次数
    for i = 1 : Lk  %  内循环，在每个温度下迭代lk次
        path1 = gen_new_path(path0);  % 调用我们自己写的gen_new_path函数生成新的路径
        result1 = calculate_tsp_d(path1,d); % 计算新路径的距离
        %如果新解距离短，则直接把新解的值赋值给原来的解
        if result1 < result0    
            path0 = path1; % 更新当前路径为新路径
            result0 = result1; 
        else
            p = exp(-(result1 - result0)/T); % 根据Metropolis准则计算一个概率
            if rand(1) < p   % 生成一个随机数和这个概率比较，如果该随机数小于这个概率
                path0 = path1;  % 更新当前路径为新路径
                result0 = result1; 
            end
        end
        % 判断是否要更新找到的最佳的解
        if result0 < min_result  % 如果当前解更好，则对其进行更新
            min_result = result0;  % 更新最小的距离
            best_path = path0;  % 更新找到的最短路径
        end
    end
    RESULT(iter) = min_result; % 保存本轮外循环结束后找到的最小距离
    T = alpfa*T;   % 温度下降       
end


disp('最佳的方案是：'); disp(mat2str(best_path))
disp('此时最优值是：'); disp(min_result)


best_path = [best_path, best_path(1)];   % 在最短路径的最后面加上一个元素，即第一个点（我们要生成一个封闭的图形）
n = n+1;  % 城市的个数加一个（紧随着上一步）
for i = 1:n-1 
    j = i+1;
    x_i = coord(best_path(i), 1);     y_i = coord(best_path(i), 2); 
    x_j = coord(best_path(j), 1);     y_j = coord(best_path(j), 2);
    plot([x_i,x_j],[y_i,y_j],'-b')    % 每两个点就作出一条线段，直到所有的城市都走完
    pause(0.1)  % 暂停0.1s再画下一条线段
    hold on
end

%% 画出每次迭代后找到的最短路径的图形
figure
plot(1:maxgen, RESULT, 'b-');
xlabel('迭代次数');
ylabel('最短路径');

toc

%% 计算路径距离
function  result =  calculate_tsp_d(path,d)
% 输入：path:路径（1至n的一个序列），d：距离矩阵
    n = length(path);
    result = 0; % 初始化该路径走的距离为0
    for i = 1:n-1  
        result = d(path(i), path(i+1)) + result;  % 按照这个序列不断的更新走过的路程这个值
    end   
    result = d(path(1), path(n)) + result;  % 加上从最后一个城市返回到最开始那个城市的距离
end

%% 生成新路径
function path1 = gen_new_path(path0)
    % path0: 原来的路径
    n = length(path0);
    % 随机选择三种产生新路径的方法
    p1 = 0.33;  % 使用交换法产生新路径的概率
    p2 = 0.33;  % 使用移位法产生新路径的概率
    r = rand(1); % 随机生成一个[0 1]间均匀分布的随机数
    if  r < p1    % 使用交换法产生新路径 
        c1 = randi(n);   % 生成1-n中的一个随机整数
        c2 = randi(n);   % 生成1-n中的一个随机整数
        path1 = path0;  % 将path0的值赋给path1
        path1(c1) = path0(c2);  %改变path1第c1个位置的元素为path0第c2个位置的元素
        path1(c2) = path0(c1);  %改变path1第c2个位置的元素为path0第c1个位置的元素
    elseif r < p1+p2 % 使用移位法产生新路径
        c1 = randi(n);   % 生成1-n中的一个随机整数
        c2 = randi(n);   % 生成1-n中的一个随机整数
        c3 = randi(n);   % 生成1-n中的一个随机整数
        sort_c = sort([c1 c2 c3]);  % 对c1 c2 c3从小到大排序
        c1 = sort_c(1);  c2 = sort_c(2);  c3 = sort_c(3);  % c1 < = c2 <=  c3
        tem1 = path0(1:c1-1);
        tem2 = path0(c1:c2);
        tem3 = path0(c2+1:c3);
        tem4 = path0(c3+1:end);
        path1 = [tem1 tem3 tem2 tem4];
    else  % 使用倒置法产生新路径
        c1 = randi(n);   % 生成1-n中的一个随机整数
        c2 = randi(n);   % 生成1-n中的一个随机整数
        if c1 > c2  % 如果c1比c2大，就交换c1和c2的值
            tem = c2;
            c2 = c1;
            c1 = tem;
        end
        tem1 = path0(1:c1-1);
        tem2 = path0(c1:c2);
        tem3 = path0(c2+1:end);
        path1 = [tem1 fliplr(tem2) tem3];   %矩阵的左右对称翻转 fliplr，上下对称翻转 flipud
    end
end