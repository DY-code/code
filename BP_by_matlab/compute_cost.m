function cost = compute_cost(AL, Y)
% Implement the cost function defined by equation (7).
% 
% Arguments:
% AL -- probability vector corresponding to your label predictions, shape (1, number of examples)
% Y -- true "label" vector (for example: containing 0 if non-cat, 1 if cat), shape (1, number of examples)
% 
% Returns:
% cost -- cross-entropy cost
    
m = size(Y, 2);

% sprintf("AL: ")
% AL
% sprintf("Y: ")
% Y

cost = -1/m * (log(AL)*(Y') + log(1-AL)*(1-Y)');
 
end
