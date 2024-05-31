A =[0,12,inf,inf,inf,16,14;12,0,10,inf,inf,7,inf;inf,10,0,3,5,6,inf;inf,inf,3,0,4,inf,inf;inf,inf,5,4,0,2,8;16,7,6,inf,2,0,9;14,inf,inf,inf,8,9,0];
start = 1;
dest = 4;
 
[~, path, connection, Distance] = fun_dijkstra(A, start, dest);
 
connection(:, dest) = [];
Distance(:, dest) = [];
s = connection(1, :);
t = connection(2, :);
weights = Distance(2, :);
names = {'A' 'B' 'C' 'D' 'E' 'F' 'G'};
 
g = digraph(s,t,weights,names);
 
plot(g,'EdgeLabel',g.Edges.Weight); hold on;

AA = A;
AA(AA == inf) = 0;
G = graph(AA);
plot(G, 'EdgeLabel', G.Edges.Weight)