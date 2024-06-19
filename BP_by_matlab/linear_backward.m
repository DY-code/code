function [dA_prev, dW, db] = linear_backward(dZ, cache)
% Implement the linear portion of backward propagation for a single layer (layer l)
% 
% Arguments:
% dZ -- Gradient of the cost with respect to the linear output (of current layer l)
% cache -- tuple of values (A_prev, W, b) coming from the forward propagation in the current layer
% 
% Returns:
% dA_prev -- Gradient of the cost with respect to the activation (of the previous layer l-1), same shape as A_prev
% dW -- Gradient of the cost with respect to W (current layer l), same shape as W
% db -- Gradient of the cost with respect to b (current layer l), same shape as b

%     A_prev, W, b = cache
A_prev = cache{1};
W = cache{2};
b = cache{3};

%     m = A_prev.shape[1]
m = size(A_prev, 2);
    
%     dW = 1/m * np.dot(dZ, A_prev.T)
%     db = 1/m * np.sum(dZ, axis=1, keepdims=True)
%     dA_prev = np.dot(W.T, dZ)

dW = 1/m * dZ * (A_prev');
db = 1/m * sum(dZ, 2); % 包含每一行总和的列向量
dA_prev = W' * dZ;
    
%     assert (dA_prev.shape == A_prev.shape)
%     assert (dW.shape == W.shape)
%     assert (db.shape == b.shape)
    
end