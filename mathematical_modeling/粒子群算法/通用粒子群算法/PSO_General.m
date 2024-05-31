pop = 10; % 种群数量
dim = 5; % 粒子群维度
ub = [5,5,5,5,5]; % 每个维度对应的边界
lb = [-5,-5,-5,-5,-5];
vmax = ones(1, dim) * 3;
vmin = -vmax;
maxIter = 100;
x = initialization(pop, ub, lb, dim);
[Best_Pos, Best_fitness, IterCurve] = ...
PSO(pop, dim, ub, lb, @get_fitness, vmax, vmin, maxIter);

%%--------------粒子群函数----------------------%%
%% 输入：
%   pop:种群数量
%   dim:单个粒子的维度
%   ub:粒子上边界信息，维度为[1,dim];
%   lb:粒子下边界信息，维度为[1,dim];
%   fobj:为适应度函数接口
%   vmax: 为速度的上边界信息，维度为[1,dim];
%   vmin: 为速度的下边界信息，维度为[1,dim];
%   maxIter: 算法的最大迭代次数，用于控制算法的停止。
%% 输出：
%   Best_Pos：为粒子群找到的最优位置
%   Best_fitness: 最优位置对应的适应度值
%   IterCure:  用于记录每次迭代的最佳适应度，即后续用来绘制迭代曲线。
function [Best_Pos, Best_fitness, BestFitness_iter] = ...
PSO(pop, dim, ub, lb, fobj, vmax, vmin, maxIter)
    %%设置学习权重
    w = 0.8; % 粒子自身惯性权重
    c1 = 2.0; % 自我学习因子
    c2 = 2.0; % 群体学习因子

    %% 初始化种群速度
    V = initialization(pop, vmax, vmin, dim);

    %% 初始化种群位置
    X = initialization(pop, ub, lb, dim);

    %% 计算初始适应度值
    fitness = zeros(1, pop);
    for i = 1:pop
       fitness(i) = fobj(X(i, :));
    end

    %% 将初始种群作为个体历史最优
    pBestPosition = X;
    pBestFitness = fitness;

    %% 记录初始全局最优解,默认优化最小值
    %寻找适应度最小的位置
    [~, index] = min(fitness);
    %记录适应度值和位置
    gBestFitness = fitness(index);
    gBestPosition = X(index, :);

    % 记录每次迭代得到的最优适应度
    BestFitness_iter = zeros(1, maxIter);

    %% 开始迭代
    for t = 1:maxIter
       %对每个粒子进行更新 
       for i = 1:pop
          %速度更新
          r1 = rand(1, dim);
          r2 = rand(1, dim);
          V(i, :) = w * V(i, :) + c1 .* r1 .* (pBestPosition(i, :) - X(i, :)) + c2 .* r2 .* (gBestPosition - X(i, :));
          %速度边界检查及约束
          V(i, :) = BoundaryCheck(V(i, :), vmax, vmin, dim);
          %位置更新
          X(i, :) = X(i, :) + V(i, :);
          %位置边界检查及约束
          X(i, :) = BoundaryCheck(X(i, :), ub, lb, dim);
          %计算新位置适应度值
          fitness(i) = fobj(X(i, :));
          %更新个体历史最优值
          if fitness(i) < pBestFitness(i)
              pBestPosition(i, :) = X(i, :);
              pBestFitness(i) = fitness(i);    
          end
          %更新全局最优值
          if fitness(i) < gBestFitness
              gBestFitness = fitness(i);
              gBestPosition = X(i, :);
          end   
       end

       %记录当前迭代的最优适应度值
       BestFitness_iter(t) = gBestFitness;   
    end

    %% 记录迭代最优值和最优适应度值
    %记录最优解
    Best_Pos = gBestPosition;
    %记录最优解的适应度值
    Best_fitness = gBestFitness;
end

%% 粒子群初始化函数
function X = initialization(pop,ub,lb,dim)
    %pop:为种群数量
    %dim:每个粒子群的维度
    %ub:为每个维度的变量上边界，维度为[1,dim];
    %lb:为每个维度的变量下边界，维度为[1,dim];
    %X:为输出的种群，维度[pop,dim];
    X = zeros(pop, dim); %为X事先分配空间
    for i = 1:pop
        for j = 1 : dim
            X(i, j) = (ub(j) - lb(j)) * rand() + lb(j);  %生成[lb,ub]之间的随机数
        end
    end
end

%% 适应度函数（可根据需要进行修改）
function fitness = get_fitness(x)
%x为输入一个粒子，维度为[1,dim];
%fitness 为输出的适应度值
    fitness = sum(x.^2);
end

%% 边界检查函数
function [X] = BoundaryCheck(x, ub, lb, dim)
    %dim为数据的维度大小
    %x为输入数据，维度为[1,dim];
    %ub为数据上边界，维度为[1,dim]
    %lb为数据下边界，维度为[1,dim]
    for i = 1:dim
        if x(i) > ub(i)
           x(i) = ub(i); 
        end
        if x(i) < lb(i)
            x(i) = lb(i);
        end
    end
    X = x;
end











