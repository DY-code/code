clear, clc, close all;
fun = @(x) x .* sin(x) .* cos(2 * x) - 2 * x .* sin(3 * x) +3 * x .* sin(4 * x); % 函数表达式    % 求这个函数的最大值  

%%
N = 100;                         % 初始种群个数  
d = 1;                          % 可行解维数  
G = 200;                      % 最大迭代次数       
Position_limit = [0, 50];               % 设置位置参数限制  
Speed_limit = [-10, 10];               % 设置速度限制  
w = 0.8;                        % 惯性权重  
c1 = 0.5;                       % 自我学习因子  
c2 = 0.5;                       % 群体学习因子   
figure(1); ezplot(fun,[0,0.01,Position_limit(2)]);   %曲线

Positions = Position_limit(1) + (Position_limit(2) -  Position_limit(1)) .* rand(N, d);%初始种群的位置  

Speed = rand(N, d);                  % 初始种群的速度  
Positions_m = Positions;                          % 每个个体的历史最佳位置  
Optimal_Position= zeros(1, d);                % 种群的历史最佳位置  
Adaptation_m = ones(N, 1)*inf;               % 每个个体的历史最佳适应度  
Optimal_Adaptation = inf;                       % 种群历史最佳适应度  
% hold on  
% plot(xm, f(xm), 'ro'); title('初始状态图');  
% figure(2)  

%% 群体更新  
% record = zeros(G, 1);          % 记录器  
for iter = 1:G  
     adaptations = fun(Positions) ; % 所有个体当前适应度     
     for i = 1:N        
        if adaptations(i) < Adaptation_m(i)  % 适应度小视为优
            Adaptation_m(i) = adaptations(i);     % 更新个体历史最佳适应度  
            Positions_m(i,:) = Positions(i,:);   % 更新个体历史最佳位置(取值)  
        end   
     end  
    if  min(Adaptation_m)  < Optimal_Adaptation 
        [Optimal_Adaptation, nmin] = min(Adaptation_m);   % 更新群体历史最佳适应度  
        Optimal_Position = Positions_m(nmin, :);      % 更新群体历史最佳位置  
    end  
    % repmat(a, b, c): 产生由数a组成的b*c矩阵
    k =  exp(-iter / 20); % 惯性权重衰减系数
    Speed = Speed * w * k + c1 * k * rand * (Positions_m - Positions) + c2 * rand * (repmat(Optimal_Position, N, 1) - Positions);% 速度更新  
    % 边界速度处理  
    Speed(Speed > Speed_limit(2)) = Speed_limit(2);  
    Speed(Speed < Speed_limit(1)) = Speed_limit(1);  
    Positions = Positions + Speed;% 位置更新  
    % 边界位置处理  
    Positions(Positions > Position_limit(2)) = Position_limit(2);  
    Positions(Positions < Position_limit(1)) = Position_limit(1);  
    record(iter) = Optimal_Adaptation;%最大值记录  
    x0 = 0 : 0.01 : Position_limit(2);  
    subplot(1,2,1);
    plot(x0, fun(x0), 'b-', Positions, fun(Positions), 'ro');
    title('状态位置变化');
    subplot(1,2,2); plot(record); 
    title('最优适应度进化过程');
    pause(0.1);
end  

x0 = 0 : 0.01 : Position_limit(2);  
figure(4); plot(x0, fun(x0), 'b-', Positions, fun(Positions), 'ro'); title('最终状态位置')  
disp(['最大值：', num2str(Optimal_Adaptation)]);  
disp(['变量取值：', num2str(Optimal_Position)]);  