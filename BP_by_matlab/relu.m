function [A, cache] =  relu(Z)
% Implement the RELU function.
% 
% Arguments:
% Z -- Output of the linear layer, of any shape
% 
% Returns:
% A -- Post-activation parameter, of the same shape as Z
% cache -- a python dictionary containing "A" ; stored for computing the backward pass efficiently
    
A = max(0, Z);
% assert(A.shape == Z.shape)
cache = Z;

end

