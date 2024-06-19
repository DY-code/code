function p = my_predict(X, y, parameters)
%     This function is used to predict the results of a  L-layer neural network.
%
%     Arguments:
%     X -- data set of examples you would like to label
%     parameters -- parameters of the trained model
%
%     Returns:
%     p -- predictions for the given dataset X

%     m = X.shape[1]
m = size(X, 2);
n = floor(length(parameters) / 2); % number of layers in the neural network
%     p = np.zeros((1,m))
p = zeros(1, m);

% Forward propagation
[probas, caches] = L_model_forward(X, parameters);


% convert probas to 0/1 predictions
%     for i in range(0, probas.shape[1]):
for i = 1:size(probas, 2)
    if probas(0, i) > 0.5
        p(0, i) = 1;
    else
        p(0, i) = 0;
    end
end

%     #print results
%     #print ("predictions: " + str(p))
%     #print ("true labels: " + str(y))
sprintf("Accuracy: %f", sum(p == y)/m);
end