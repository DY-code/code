function [A, cache] = linear_activation_forward(A_prev, W, b, activation)
% 实现单层前向传播 线性加和+激活函数
% 
% Arguments:
% A_prev -- activations from previous layer (or input data): (size of previous layer, number of examples)
% W -- weights matrix: numpy array of shape (size of current layer, size of previous layer)
% b -- bias vector, numpy array of shape (size of the current layer, 1)
% activation -- the activation to be used in this layer, stored as a text string: "sigmoid" or "relu"
% 
% Returns:
% A -- the output of the activation function, also called the post-activation value 
% cache -- a python dictionary containing "linear_cache" and "activation_cache";
%          stored for computing the backward pass efficiently
if activation == "sigmoid"
    % nputs: "A_prev, W, b". Outputs: "A, activation_cache".
    [Z, linear_cache] = linear_forward(A_prev, W, b);
    [A, activation_cache] = sigmoid(Z);
elseif activation == "relu"
    % Inputs: "A_prev, W, b". Outputs: "A, activation_cache".
    [Z, linear_cache] = linear_forward(A_prev, W, b);
    [A, activation_cache] = relu(Z);
end

%     assert (A.shape == (W.shape[0], A_prev.shape[1]))
cache = {linear_cache, activation_cache};

% sprintf("cache")
% cache

end