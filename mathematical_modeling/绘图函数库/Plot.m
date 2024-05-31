x = -3.5 : 0.2 : 3.5; y = -3.5 : 0.2 : 3.5;
[X,Y] = meshgrid(x,y); Z = X .* exp(-X .^ 2- Y .^ 2);
subplot(1,3,1); contour(Z,[-0.45 : 0.05 : 0.45]); axis square;
subplot(1,3,2); [C,h] = contour(Z);
clabel(C,h); axis square;
subplot(1,3,3);
contourf(Z);	%涂色
axis square;