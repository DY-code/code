clear, clc, close all;
fun = @(x,y)   20 +  x.^2 + y.^2 - 10*cos(2*pi.*x)  - 10*cos(2*pi.*y); %[-5.12 ,5.12 ]
 
%% 初始化种群  
x0 = -5.12 : 0.05 : 5.12;
y0 = x0 ;
[X,Y] = meshgrid(x0,y0);
Z = fun(X, Y);
figure(1); mesh(X, Y ,Z);  
colormap(parula(5));

N = 50;                         % 初始种群个数  
d = 2;                          % 可行解维数  
G = 100;                      % 最大迭代次数       
limit = [-5.12,5.12];               % 设置位置参数限制  
Speed_limit = [-0.5, 0.5];               % 设置速度限制  
w = 0.8;                        % 惯性权重  
c1 = 0.5;                       % 自我学习因子  
c2 = 0.5;                       % 群体学习因子   

Positions = limit(1) + (limit(2) -  limit(1)) .* rand(N, d);%初始种群的位置  

Speed = rand(N, d);                  % 初始种群的速度  
Positions_m = Positions;                          % 每个个体的历史最佳位置  
Optimal_Position = zeros(1, d);                % 种群的历史最佳位置  
Adaptation_m = ones(N, 1)*inf;               % 每个个体的历史最佳适应度   
Optimal_Adaptation = inf;                       % 种群历史最佳适应度  
% record = zeros(ger,1);
% hold on 
% [X,Y] = meshgrid(x(:,1), x(:,2));
% Z = f(X, Y) ;
% scatter3(Positions(:, 1), Positions(:, 2), fun(Positions(:, 1), Positions(:, 2)), 'r*' );
% figure(2);
record = [];  % 记录最佳适应度

%% 群体更新  
% record = zeros(ger, 1);          % 记录器  
for iter = 1:G  
     fx = fun(Positions(:,1),Positions(:,2) ) ;% 个体当前适应度     
     for i = 1:N        
        if  fx(i)  < Adaptation_m(i) 
            Adaptation_m(i) = fx(i);     % 更新个体历史最佳适应度  
            Positions_m(i,:) = Positions(i,:);   % 更新个体历史最佳位置(取值)  
        end   
     end  
    if min(Adaptation_m) <  Optimal_Adaptation
        [Optimal_Adaptation, nmin] = min(Adaptation_m);   % 更新群体历史最佳适应度  
        Optimal_Position = Positions_m(nmin, :);      % 更新群体历史最佳位置  
    end  
    k = exp(-iter / G * 10);
    Speed = Speed * w * k + c1 * k * rand * (Positions_m - Positions) + ...
            c2 * rand * (repmat(Optimal_Position, N, 1) - Positions);% 速度更新  
    % 边界速度处理  
    Speed(Speed > Speed_limit(2)) = Speed_limit(2);  
    Speed(Speed < Speed_limit(1)) = Speed_limit(1);  
    Positions = Positions + Speed;% 位置更新  
    % 边界位置处理  
    Positions(Positions > limit(2)) = limit(2);  
    Positions(Positions < limit(1)) = limit(1);  
    record(iter) = Optimal_Adaptation;%最大值记录  

    subplot(1, 2, 1);
    mesh(X, Y, Z);
    hold on;
    scatter3(Positions(:, 1), Positions(:, 2), fun(Positions(:, 1), Positions(:, 2)), 'r*');
    title(['状态位置变化','-迭代次数：', num2str(iter)]);
    subplot(1,2,2);
    plot(record);
    title('最优适应度进化过程');
    pause(0.01);
end  

%%
figure(4);
mesh(X, Y, Z); hold on 
scatter3(Positions(:, 1), Positions(:, 2), fun(Positions(:, 1), Positions(:, 2)), 'r*');
title('最终状态位置');  
disp(['最优值：', num2str(Optimal_Adaptation)]);  
disp(['变量取值：', num2str(Optimal_Position)]);  
