function [dA_prev, dW, db] = linear_activation_backward(dA, cache, activation)
% Implement the backward propagation for the LINEAR->ACTIVATION layer.
% 
% Arguments:
% dA -- post-activation gradient for current layer l 
% cache -- tuple of values (linear_cache, activation_cache) we store for computing backward propagation efficiently
% activation -- the activation to be used in this layer, stored as a text string: "sigmoid" or "relu"
% 
% Returns:
% dA_prev -- Gradient of the cost with respect to the activation (of the previous layer l-1), same shape as A_prev
% dW -- Gradient of the cost with respect to W (current layer l), same shape as W
% db -- Gradient of the cost with respect to b (current layer l), same shape as b

% linear_cache, activation_cache = cache;
linear_cache = cache{1};
activation_cache = cache{2};

if activation == "relu"
    dZ = relu_backward(dA, activation_cache);
    [dA_prev, dW, db] = linear_backward(dZ, linear_cache);
elseif activation == "sigmoid"
    dZ = sigmoid_backward(dA, activation_cache);
    [dA_prev, dW, db] = linear_backward(dZ, linear_cache);
end
    
end