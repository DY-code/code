function parameters = initialize_parameters_deep(layer_dims)
% 模型参数初始化
% Arguments:
% layer_dims -- list containing the dimensions of each layer in our network
% 
% Returns:
% parameters -- python dictionary containing your parameters "W1", "b1", ..., "WL", "bL":
%                 Wl -- weight matrix of shape (layer_dims[l], layer_dims[l-1])
%                 bl -- bias vector of shape (layer_dims[l], 1)

parameters = {};
L = size(layer_dims, 2);

for l = 1:L-1
    % W
    parameters{2*l-1} = randn(layer_dims(l+1), layer_dims(l)) * 0.1;
    % b
    parameters{2*l} = randn(layer_dims(l+1), 1) * 0.1;
    %         assert(parameters['W' + str(l)].shape == (layer_dims[l], layer_dims[l-1]))
    %         assert(parameters['b' + str(l)].shape == (layer_dims[l], 1))
end
end