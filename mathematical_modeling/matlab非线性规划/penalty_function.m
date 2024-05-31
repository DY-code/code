% 罚函数法求解非线性规划问题
% 非线性规划问题的求解，转化为求解一系列无约束极值问题
XO = [];
YO = inf;
for i = 1 : 1000
    [x, y] = fmincon(@test, rand(2, 1));
    if y < YO
        XO = x;
        YO = y
    end
end

%%
function g = test(x)
M = 50000;
f = x(1)^2 + x(2)^2 + 8;
g = f - M*min(x(1), 0) - M*min(x(2), 0) ...
    - M*min(x(1)^2 - x(2), 0) + M*abs(-x(1) - x(2)^2 + 2);
end

