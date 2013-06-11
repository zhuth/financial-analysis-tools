%% run clustering test

p = size(data1, 2); q = size(data2, 2);
thre = 1e-3;
eval = [];

lda = [];
if ~exist('nolda')
    % lda - init
    disp('lda - init');
    lda.s = s; lda.t = t; lda.eval = [];
    [lda.P, lda1] = lda_exe('lda_nips_doc', lda.s, 1, 50/s);
    [lda.Q, lda2] = lda_exe('lda_nips_abs', lda.t, 1, 50/t);
    lda.data1 = data1; lda.data2 = data2;
    lda.cluster = lda1 * lda.t + lda2;
    lda = runtestfunc(E, lda);
    lda.eval = [lda.eval evaluateClustering([lda.cluster; clustergt], 0)];
    lda.eval = [lda.eval evaluateClustering([lda.cluster; clustergt], 1)];
    lda.eval = [lda.eval evaluateClustering([clustering(lda); clustergt], 0)];
    lda.eval = [lda.eval evaluateClustering([clustering(lda); clustergt], 1)];
end;

% plsa - init
pl = [];
if ~exist('noplsa')
    disp('plsa - init');
    pl.s = s; pl.t = t; pl.eval = [];
    [pz pdz1 pl.P] = plsa(data1', pl.s);
    [pz pdz2 pl.Q] = plsa(data2', pl.t);
    [mv lplsa1] = max(pdz1);
    [mv lplsa2] = max(pdz2);
    pl.P = pl.P'; pl.Q = pl.Q';
    pl.cluster = lplsa1 * pl.t + lplsa2;
    pl.data1 = data1; pl.data2 = data2;
    pl = runtestfunc(E, pl);
    pl.eval = [pl.eval evaluateClustering([pl.cluster; clustergt], 0)];
    pl.eval = [pl.eval evaluateClustering([pl.cluster; clustergt], 1)];
    pl.eval = [pl.eval evaluateClustering([clustering(pl); clustergt], 0)];
    pl.eval = [pl.eval evaluateClustering([clustering(pl); clustergt], 1)];
end;

% random projection - init
rp = [];
if ~exist('norp')
    disp('rp - init');
    rp.data1 = rndprj(data1, int32(sqrt(p)));
    rp.data2 = rndprj(data2, int32(sqrt(q)));
    [lrp1 rp.P] = skmeans(rp.data1, s);
    [lrp2 rp.Q] = skmeans(rp.data2, t);
    rp.P = rp.P'; rp.Q = rp.Q';
    rp.cluster = lrp1' * t + lrp2';
    rp = runtestfunc(getEXY(rp.data1, rp.data2), rp);
    rp.eval = [evaluateClustering([rp.cluster; clustergt], 0) evaluateClustering([rp.cluster; clustergt], 1) evaluateClustering([clustering(rp); clustergt], 0) evaluateClustering([clustering(rp); clustergt], 1)];
end;

% kmeans - init
km = [];
if ~exist('nokm')
    disp('kmeans - init');
    [lkm1 km.P] = skmeans(data1, s); km.P = km.P';
    [lkm2 km.Q] = skmeans(data2, t); km.Q = km.Q';
    km.data1 = data1; km.data2 = data2;
    km.cluster = lkm1' * t + lkm2';
    km = runtestfunc(E, km);
    km.eval = [evaluateClustering([km.cluster; clustergt], 0) evaluateClustering([km.cluster; clustergt], 1) evaluateClustering([clustering(km); clustergt], 0)  evaluateClustering([clustering(km); clustergt], 1)];
end;

% nnmf - init
nn = [];
if ~exist('nonn')
    disp('nnmf - init');
    [nn.P r1] = nnmf(data1', s);
    [nn.Q r2] = nnmf(data2', t);
    nn.data1 = data1; nn.data2 = data2;
    lnn1 = skmeans(r1', s)';
    lnn2 = skmeans(r2', t)';
    nn.cluster = lnn1 * t + lnn2;
    nn = runtestfunc(E, nn);
    nn.eval = [evaluateClustering([nn.cluster; clustergt], 0) evaluateClustering([nn.cluster; clustergt], 1) evaluateClustering([clustering(nn); clustergt], 0)  evaluateClustering([clustering(nn); clustergt], 1)];
end;

% nnmf3
nn3 = [];
if ~exist('nonn3')
    disp('nn3');
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
    nn3.eval = [0 0 e f];
end;

e0 = eval(:, mod([0:end-1],4)<2);
e1 = eval(:, mod([0:end-1],4)>=2);
ef = (1-e0).*(1-e1)*2./(2-e0-e1);