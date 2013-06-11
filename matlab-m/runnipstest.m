%% run clustering test

p = size(data1, 2); q = size(data2, 2);
thre = 1e-3;
eval = [];

% lda - init
disp('lda - init');
lda = [];
lda.s = s; lda.t = t; lda.eval = [];
while 1,
    [lda.P, lda1] = lda_exe(data1, lda.s, 1, 50/s);
    [lda.Q, lda2] = lda_exe(data2, lda.t, 1, 50/t);
    lda.data1 = data1; lda.data2 = data2;
    lda.cluster = lda1 * lda.t + lda2;
    A = lsqA(E, lda.P, lda.Q);
    lda.eval = [lda.eval evaluateClustering([lda.cluster; clustergt], 0)];
    lda.eval = [lda.eval evaluateClustering([lda.cluster; clustergt], 1)];
    lda.eval = [lda.eval evaluateClustering([clustering(lda); clustergt], 0)];
    lda.eval = [lda.eval evaluateClustering([clustering(lda); clustergt], 1)];
    lda.sn = sum(sum(A')>thre);
    lda.tn = sum(sum(A)>thre);
    if (lda.sn == lda.s & lda.tn == lda.t), break; end;
end;

% plsa - init
disp('plsa - init');
pl = [];
pl.s = s; pl.t = t; pl.eval = [];
while 1,
    [pz pdz1 pl.P] = plsa(data1', pl.s);
    [pz pdz2 pl.Q] = plsa(data2', pl.t);
    [mv lplsa1] = max(pdz1);
    [mv lplsa2] = max(pdz2);
    pl.P = pl.P'; pl.Q = pl.Q';
    A = lsqA(E, pl.P, pl.Q);
    pl.cluster = lplsa1 * pl.t + lplsa2;
    pl.data1 = data1; pl.data2 = data2;
    pl.eval = [pl.eval evaluateClustering([pl.cluster; clustergt], 0)];
    pl.eval = [pl.eval evaluateClustering([pl.cluster; clustergt], 1)];
    pl.eval = [pl.eval evaluateClustering([clustering(pl); clustergt], 0)];
    pl.eval = [pl.eval evaluateClustering([clustering(pl); clustergt], 1)];
    pl.sn = sum(sum(A')>thre); pl.tn = sum(sum(A)>thre);
    if (pl.sn == pl.s & pl.tn == pl.t), break; end;
end;

% random projection - init
disp('rp - init');
rp = [];
rp.data1 = rndprj(data1, int32(sqrt(p)));
rp.data2 = rndprj(data2, int32(sqrt(q)));
[lrp1 rp.P] = skmeans(rp.data1, s);
[lrp2 rp.Q] = skmeans(rp.data2, t);
rp.P = rp.P'; rp.Q = rp.Q';
rp.cluster = lrp1' * t + lrp2';
for allowSplit = 0 : 1
    eval = [eval evaluateClustering([rp.cluster; clustergt], allowSplit)];
    eval = [eval evaluateClustering([clustering(rp); clustergt], allowSplit)];
end;

% kmeans - init
disp('kmeans - init');
km = [];
[lkm1 km.P] = skmeans(data1, s); km.P = km.P';
[lkm2 km.Q] = skmeans(data2, t); km.Q = km.Q';
km.data1 = data1; km.data2 = data2;
km.cluster = lkm1' * t + lkm2';
for allowSplit = 0 : 1
    eval = [eval evaluateClustering([km.cluster; clustergt], allowSplit)];
    eval = [eval evaluateClustering([clustering(km); clustergt], allowSplit)];
end;

% nnmf - init
disp('nnmf - init');
nn = [];
[nn.P r1] = nnmf(data1', s);
[nn.Q r2] = nnmf(data2', t);
nn.data1 = data1; nn.data2 = data2;
lnn1 = skmeans(r1', s)';
lnn2 = skmeans(r2', t)';
nn.cluster = lnn1 * t + lnn2;
for allowSplit = 0 : 1
    eval = [eval evaluateClustering([nn.cluster; clustergt], allowSplit)];
    eval = [eval evaluateClustering([clustering(nn); clustergt], allowSplit)];
end;

% nnmf3
E = getEXY(data1, data2, 0);
nn3 = [];
e = 1; f = 1;
for tries = 1 : 10
    [nn3.P nn3.A nn3.Q] = nnmf3(E, s, t);
    nn3.data1 = data1; nn3.data2 = data2;
    nn3.cluster = clustering(nn3);
    e1 = evaluateClustering([nn3.cluster; clustergt], 0);
    e2 = evaluateClustering([nn3.cluster; clustergt], 1);
    if (e1 < e)
        e = e1;
        f = e2;
    end;
end;
eval = [eval e 0 f 0];

e0 = eval(:, mod([0:end-1],4)<2);
e1 = eval(:, mod([0:end-1],4)>=2);
ef = (1-e0).*(1-e1)*2./(2-e0-e1);