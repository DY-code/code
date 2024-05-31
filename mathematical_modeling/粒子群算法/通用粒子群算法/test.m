clear, clc, close all;
pop = 50;
G = 100;
dim = 2;
ub = ones(1, 2) * 5.12;
lb = -ub;
vmax = ones(1, 2) * 0.5;
vmin = -vmax;

[best_position, best_fitness, best_fitness_iter] = PSO_fun(pop, dim, ub, lb, @fun, vmax, vmin, G);

% x0 = -5.12 : 0.05 : 5.12;
% y0 = x0;
% [X, Y] = meshgrid(x0,y0);
% for i = 1 : size(X, 2)
%     Z(:, i) = fun([X(:, i), Y(:, i)]);
% end
% mesh(X, Y ,Z); hold on;
% colormap(parula(5));
% 
% plot(best_position(1), best_position(2), '*r');
% figure
% plot(best_fitness_iter)

function fitness = fun(X)
fitness = 20 + X(:, 1) .^ 2 + ...
    X(:, 2) .^ 2 - 10*cos(2*pi*X(:, 1)) - 10*cos(2*pi.*X(:, 2));
end
