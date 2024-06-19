function parameters = update_parameters(parameters, grads, learning_rate)
% Update parameters using gradient descent
% 
% Arguments:
% parameters -- python dictionary containing your parameters 
% grads -- python dictionary containing your gradients, output of L_model_backward
% 
% Returns:
% parameters -- python dictionary containing your updated parameters 
%               parameters["W" + str(l)] = ... 
%               parameters["b" + str(l)] = ...
    
L = round(length(parameters) / 2); % number of layers in the neural network

% Update rule for each parameter. Use a for loop.
for layer = 1:L
    parameters{2*layer - 1} = parameters{2*layer - 1} - learning_rate*grads.("dW" + num2str(layer));
    parameters{2*layer} = parameters{2*layer} - learning_rate*grads.("db" + num2str(layer));
end

end