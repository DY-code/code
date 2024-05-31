clear, clc;
% 02~21年GDP数据
data = [121717.4, 137422, 161840.2, 187318.9, 219438.5, 270092.3, 319244.6, 348517.7, ...
    412119.3, 487940.2, 538580, 592963.2, 643563.1, 688858.2, 746395.1, 832035.9, ...
    919281.1, 986515.2, 1013567, 1143669.7]';

%% 级比检验
n = length(data);
c = 1000000;
data = data + c;  % 原始数据级比不满足限制要求，做平移变换
lamda = data(1 : n - 1) ./ data(2 : n);
range = minmax(lamda');  % 找出所有级比的最值
lamda_min = exp(-2 / (n + 1));  % 限制范围
lamda_max = exp(2 / (n + 1)); 

%% 构造数据矩阵
data1 = cumsum(data);  % 累加运算
B = [-0.5 * (data1(1 : n - 1) + data1(2 : n)), ones(n - 1, 1)];  % 数据矩阵
Y= data(2 : n);  % 向量矩阵
u = B \ Y;  % 拟合参数a, b

%% 求解微分方程
syms x(t)
x = dsolve(diff(x) + u(1) * x == u(2), x(2002) == data(1));   % 求微分方程的符号解
data1_hat = subs(x, t, [2002 : 2021]);  % 序列预测值
data1_hat = double(data1_hat);  % 结果转换为数值类型
data_hat = [data(1), diff(data1_hat)] - c;  % GDP预测值，平移还原数据

%% 数据分析
epsilon = data - c - data_hat';  % 残差
delta = abs(epsilon ./ data);  % 相对误差
rho = 1 - (1 - 0.5 * u(1)) / (1 + 0.5 * u(1)) * lamda;  % 级比偏差值

plot(data - c, 'o'); hold on;
plot(data_hat, '*'); hold on;
legend('data', 'data_hat')

%% GDP预测
data1_hat = subs(x, t, [2002 : 2021 + 10]);  % 序列预测值
data1_hat = double(data1_hat);  % 结果转换为数值类型
data_hat = [data(1), diff(data1_hat)] - c;  % GDP预测值，平移还原数据

figure;
plot(2002 : 2021, data - c, '-o'); hold on;
plot(2002 : 2021 + 10, data_hat, '-*'); hold on;
legend('实际GDP', '预测GDP');
xlabel('年度');
ylabel('中国国内生产总值（GDP）');
















