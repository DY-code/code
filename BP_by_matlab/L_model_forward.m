function [AL, caches] = L_model_forward(X, parameters)
% 实现模型的前向传播部分 [linear -> relu]*(L-1) -> linear -> sigmoid
% 
% Arguments:
% X -- data, numpy array of shape (input size, number of examples)
% parameters -- output of initialize_parameters_deep()
% 
% Returns:
% AL -- last post-activation value
% caches -- list of caches containing:
%             every cache of linear_relu_forward() (there are L-1 of them, indexed from 0 to L-2)
%             the cache of linear_sigmoid_forward() (there is one, indexed L-1)

caches = {};
A = X;
% number of layers in the neural network
L = round(size(parameters, 2) / 2);

% sprintf("L: %d", L)

% linear -> relu 执行L-1次
for layer = 1:L-1
    % 该层的输入数据
    A_prev = A;

%     size(A_prev)
%     size(parameters{2*layer - 1})
%     size(parameters{2*layer})

    % linear -> activation
    [A, cache] = linear_activation_forward(A_prev, parameters{2*layer - 1}, parameters{2*layer}, "relu");
%     caches = [caches, cache];
    caches{layer} = cache;
end

% linear -> sigmoid
[AL, cache] = linear_activation_forward(A, parameters{2*L - 1}, parameters{2*L}, "sigmoid");
% caches = [caches, cache];
caches{L} = cache;
end