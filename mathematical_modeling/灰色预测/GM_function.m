function data_hat = GM_function(X, Y, Xhat)  % X Y: 原始数据(行向量), Xhat: 待预测数据, y: 预测数据

row_data = Y';  % 原始数据

%% 级比检验
data = row_data;
n = length(data);
c = 0;  % 数据平移
lamda_min = exp(-2 / (n + 1));  % 级比限制范围
lamda_max = exp(2 / (n + 1)); 
while 1
    lamda = data(1 : n - 1) ./ data(2 : n);
    range = minmax(lamda');  % 找出所有级比的最值
    if range(1) >= lamda_min && range(2) <= lamda_max  % 满足限制要求
        break;
    else  % 否则，做平移变换
        c = c + 1;
        data = row_data + c;
    end
end

%% 构造数据矩阵
data1 = cumsum(data);  % 累加运算
B = [-0.5 * (data1(1 : n - 1) + data1(2 : n)), ones(n - 1, 1)];  % 数据矩阵
Y= data(2 : n);  % 向量矩阵
u = B \ Y;  % 拟合参数a, b

%% 求解微分方程
syms x(t)
x = dsolve(diff(x) + u(1) * x == u(2), x(X(1)) == data(1));   % 求微分方程的符号解
data1_hat = subs(x, t, Xhat);  % 序列预测值，包含第1个
data1_hat = double(data1_hat);  % 结果转换为数值类型
% diff(data1_hat)得到data_hat后n-1个预测值，第一个预测值与原始数据保持一致
data_hat = [data(1), diff(data1_hat)];  % GDP预测值
data_hat = data_hat - c;  % 平移还原数据

%% GDP预测
% figure;
% plot(X, row_data, '-o'); hold on;
% plot(Xhat, data_hat, '-*'); hold on;
% legend('实际GDP', '预测GDP');
% xlabel('年度');
% ylabel('中国国内生产总值（GDP）');
end

































