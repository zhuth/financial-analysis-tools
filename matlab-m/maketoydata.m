%% Make toy data
function [data1, data2, E, clustergt] = maketoydata(par)
if (nargin < 1),
    par = [];
    par.Nd = 1000;
    par.Wdn = 200;
    par.Wd = 100;
    par.Wu = 500;
    par.small = 1e-2;
    par.s = 20; par.t = 10;
end;
P = zeros(par.s * par.Wd + par.Wu, par.s) + par.small;
Q = zeros(par.t * par.Wd + par.Wu, par.t) + par.small;
for i = 1 : par.s
    P(((i - 1) * par.Wd + 1) : (i * par.Wd), i) = rand(1, par.Wd) + par.small * 10;
end;
for i = 1 : par.t
    Q(((i - 1) * par.Wd + 1) : (i * par.Wd), i) = rand(1, par.Wd) + par.small * 10;
end;
P = normalize(P); Q = normalize(Q);
A = rand(par.s, par.t); A = A .* (A >= 0.5); A = A ./ sum(A(:));

% draw documents
data1 = zeros(par.Nd, par.s * par.Wd + par.Wu);
data2 = zeros(par.Nd, par.t * par.Wd + par.Wu);
clustergt = zeros(1, par.Nd);
for i = 1 : par.Nd
    idx = find(mnrnd(1, A(:)));
    clustergt(i) = idx;
    sel_T = mod(idx-1, par.t)+1;
    sel_S = floor((idx-1)/par.t)+1;
    data1(i, :) = mnrnd(par.Wdn, P(:,sel_S));
    data2(i, :) = mnrnd(par.Wdn, Q(:,sel_T));
end;
E = getEXY(data1, data2, 0);