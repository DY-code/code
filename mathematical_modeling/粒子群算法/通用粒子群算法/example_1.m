%% 基于粒子群算法的压力容器设计
clc;clear all;close all;
%粒子群参数设定
pop = 50;%种群数量
dim = 4;%变量维度
ub =[100,100,100,100];%粒子上边界信息
lb = [0,0,10,10];%粒子下边界信息
vmax = [2,2,2,2];%粒子的速度上边界
vmin = [-2,-2,-2,-2];%粒子的速度下边界
maxIter = 500;%最大迭代次数
fobj = @(x) fun(x);%设置适应度函数为fun1(x); 
%粒子群求解问题
[Best_Pos,Best_fitness,IterCurve] = PSO_fun(pop,dim,ub,lb,fobj,vmax,vmin,maxIter);
%绘制迭代曲线
figure
plot(IterCurve,'r-','linewidth',1.5);
grid on;%网格开
title('粒子群迭代曲线')
xlabel('迭代次数')
ylabel('适应度值')

disp(['求解得到的x1,x2,x3,x4为:',num2str(Best_Pos(1)),'   ',num2str(Best_Pos(2)),' ',num2str(Best_Pos(3)),' ',num2str(Best_Pos(4))]);
disp(['最优解对应的函数值为：',num2str(Best_fitness)]);
% 有约束的适应度函数
function fitness = fun(x)
    x1 = x(1); %Ts
    x2 = x(2); %Th
    x3 = x(3); %R
    x4 = x(4); %L

    %% 约束条件判断
    g1 = -x1+0.0193*x3;
    g2=-x2+0.00954*x3;
    g3=-pi*x3^2-4*pi*x3^3/3+1296000;
    g4=x4-240;
    if(g1<=0&&g2<=0&&g3<=0&&g4<=0)%如果满足约束条件则计算适应度值
       fitness = 0.6224*x1*x3*x4 + 1.7781*x2*x3^2 + 3.1661*x1^2*x4 + 19.84*x1^2*x3;
    else%否则适应度值无效
        fitness = inf;
    end

end