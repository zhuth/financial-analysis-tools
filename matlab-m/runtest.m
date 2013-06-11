%% run clustering test

p = size(data1, 2); q = size(data2, 2);
thre = 1e-3;
eval = [];

lda = [];
if ~exist('nolda')
    % lda - init
    disp('lda - init');
    lda.s = s; lda.t = t; lda.eval = [];
    [lda.P, lda.cluster1] = lda_exe(data1, lda.s, 1, 50/s);
    [lda.Q, lda.cluster2] = lda_exe(data2, lda.t, 1, 50/t);
    lda.data1 = data1; lda.data2 = data2;
    lda.cluster = lda.cluster1 * lda.t + lda.cluster2;
    lda = runtestfunc(E, lda, clustergt);
end;

% plsa - init
pl = [];
if ~exist('noplsa')
    disp('plsa - init');
    pl.s = s; pl.t = t; pl.eval = [];
    [pz pdz1 pl.P] = plsa(data1', pl.s);
    [pz pdz2 pl.Q] = plsa(data2', pl.t);
    [mv pl.cluster1] = max(pdz1);
    [mv pl.cluster2] = max(pdz2);
    pl.P = pl.P'; pl.Q = pl.Q';
    pl.cluster = pl.cluster1 * pl.t + pl.cluster2;
    pl.data1 = data1; pl.data2 = data2;
    pl = runtestfunc(E, pl, clustergt);
end;

% random projection - init
rp = [];
if ~exist('norp')
    disp('rp - init');
    rp.data1 = rndprj(data1, int32(sqrt(p)));
    rp.data2 = rndprj(data2, int32(sqrt(q)));
    [rp.cluster1 rp.P] = skmeans(rp.data1, s);
    [rp.cluster2 rp.Q] = skmeans(rp.data2, t);
    rp.P = rp.P'; rp.Q = rp.Q';
    rp.cluster = rp.cluster1' * t + rp.cluster2';
    rp = runtestfunc(getEXY(rp.data1, rp.data2), rp, clustergt);
end;

% kmeans - init
km = [];
if ~exist('nokm')
    disp('kmeans - init');
    [km.cluster1 km.P] = skmeans(data1, s); km.P = km.P';
    [km.cluster2 km.Q] = skmeans(data2, t); km.Q = km.Q';
    km.data1 = data1; km.data2 = data2;
    km.cluster = km.cluster1' * t + km.cluster2';
    km = runtestfunc(E, km, clustergt);
end;

% nnmf - init
nn = [];
if ~exist('nonn')
    disp('nnmf - init');
    [nn.P r1] = nnmf(data1', s);
    [nn.Q r2] = nnmf(data2', t);
    nn.data1 = data1; nn.data2 = data2;
    nn.cluster1 = skmeans(r1', s)';
    nn.cluster2 = skmeans(r2', t)';
    nn.cluster = nn.cluster1 * t + nn.cluster2;
    nn = runtestfunc(E, nn, clustergt);
end;

% nnmf3
nn3 = [];
[nn3.P0 nn3.A nn3.Q0] = nnmf3(E, s, t);
nn3.data1 = data1; nn3.data2 = data2;
nn3.cluster = clustering(nn3); nn3.mfcluster = nn3.cluster;
[nn3.e0mf cov] = evaluateClustering([nn3.cluster; clustergt], 0);
nn3.nmimf = nmi(nn3.cluster, clustergt);
%nn.eval_miemf = mutualinfo(cov);
%nn3.eval = [0 0 e1 e2];

e0 = eval(:, mod([0:end-1],4)<2);
e1 = eval(:, mod([0:end-1],4)>=2);
ef = (1-e0).*(1-e1)*2./(2-e0-e1);