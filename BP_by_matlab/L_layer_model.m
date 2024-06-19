clc, clear, close all;

%% 产生训练数据 
% 标签数据限定范围0~1
x = 0 : 0.05 : 3 * pi; % 自变量
y = sin(x) + exp(-x); % 因变量
y = (y - min(y))/(max(y) - min(y));

% 函数参数设置
X = x;
Y = y;
layers_dims = [1, 10, 10, 10, 1];
learning_rate = 0.05;
num_iterations = 10000;
print_cost = 1;

%%
% function parameters = L_layer_model(X, Y, layers_dims, learning_rate, num_iterations, print_cost)
% 构建L层神经网络：[LINEAR->RELU]*(L-1)->LINEAR->SIGMOID
% X, Y：训练所用数据
% layers_dims：各层神经元数量，包括输入层和输出层

costs = [];
% 模型参数初始化
parameters = initialize_parameters_deep(layers_dims);
L = round(length(parameters) / 2); 
% 迭代训练
for i = 1:num_iterations
    % 前向传播: [LINEAR -> RELU]*(L-1) -> LINEAR -> SIGMOID.
    [AL, caches] = L_model_forward(X, parameters);

    % 计算损失函数
    cost = compute_cost(AL, Y);
    
    % 反向传播
    grads = L_model_backward(AL, Y, caches);
 
    % 更新参数
%     thres = exp(-i/5000);
%     if rand < thres % rand:[0, 1]均匀分布
%         for layer = 1:L
%             parameters{2*layer - 1} = parameters{2*layer - 1} - 4*rand*grads.("dW" + num2str(layer));
%             parameters{2*layer} = parameters{2*layer} - 4*rand*grads.("db" + num2str(layer));
%         end
%     else
%         parameters = update_parameters(parameters, grads, learning_rate);
%     end
    parameters = update_parameters(parameters, grads, learning_rate);
                
    % 打印损失函数
%     sprintf("Cost after iteration %i: %f", i, cost)
    costs(i) = cost;

    i, cost
end
            
% 绘制损失函数变化图
plot(costs)
ylabel('cost')
xlabel('iterations (per tens)')
title("Learning rate =" + num2str(learning_rate))

%%
[probas, caches] = L_model_forward(X, parameters);

figure
plot(probas), hold on;
plot(y)

% end
