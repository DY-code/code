function grads = L_model_backward(AL, Y, caches)
% Implement the backward propagation for the [LINEAR->RELU] * (L-1) -> LINEAR -> SIGMOID group
% 
% Arguments:
% AL -- probability vector, output of the forward propagation (L_model_forward())
% Y -- true "label" vector (containing 0 if non-cat, 1 if cat)
% caches -- list of caches containing:
%             every cache of linear_activation_forward() with "relu" (it's caches[l], for l in range(L-1) i.e l = 0...L-2)
%             the cache of linear_activation_forward() with "sigmoid" (it's caches[L-1])
% 
% Returns:
% grads -- A dictionary with the gradients
%          grads["dA" + str(l)] = ...
%          grads["dW" + str(l)] = ...
%          grads["db" + str(l)] = ...


grads = {};
% caches: [(linear_cache, activation_cache), ...]
L = length(caches); % the number of layers
%     m = AL.shape[1]
m = size(AL, 2);
% Y = Y.reshape(AL.shape) # after this line, Y is the same shape as AL

% Initializing the backpropagation
% dAL = - (np.divide(Y, AL) - np.divide(1 - Y, 1 - AL)) % derivative of cost with respect to AL
dAL = -(Y./AL - (1-Y)./(1-AL));
    
% Lth layer (SIGMOID -> LINEAR) gradients. Inputs: "AL, Y, caches". Outputs: "grads["dAL"], grads["dWL"], grads["dbL"]
grads.("dA" + num2str(L)) = dAL;
% grads["dA"+str(L-1)], grads["dW"+str(L)], grads["db"+str(L)] = linear_activation_backward(dAL, caches[L-1], "sigmoid")
[grads.("dA" + num2str(L-1)), grads.("dW" + num2str(L)), grads.("db" + num2str(L))] ...
    = linear_activation_backward(dAL, caches{L}, "sigmoid");

    
for layer = 3:-1:1
    % lth layer: (RELU -> LINEAR) gradients.
    % Inputs: "grads["dA" + str(l + 2)], caches". Outputs: "grads["dA" + str(l + 1)] , grads["dW" + str(l + 1)] , grads["db" + str(l + 1)] 
    [grads.("dA" + num2str(layer-1)), grads.("dW" + num2str(layer)), grads.("db" + num2str(layer))] ...
        = linear_activation_backward(grads.("dA" + num2str(layer)), caches{layer}, "relu");
end
end