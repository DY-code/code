function [Z, cache] = linear_forward(A, W, b)
% 实现单层前向传播中的线性部分
% 
% Arguments:
% A -- activations from previous layer (or input data): (size of previous layer, number of examples)
% W -- weights matrix: numpy array of shape (size of current layer, size of previous layer)
% b -- bias vector, numpy array of shape (size of the current layer, 1)
% 
% Returns:
% Z -- the input of the activation function, also called pre-activation parameter 
% cache -- a python dictionary containing "A", "W" and "b" ; stored for computing the backward pass efficiently
    


Z = W*A + b;
% assert(Z.shape == (W.shape[0], A.shape[1]))

% sprintf("size(A)"), size(A)
% sprintf("size(W)"), size(W)
% sprintf("size(b)"), size(b)

cache = {A, W, b};

end