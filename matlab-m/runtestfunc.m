function model = runtestfunc(E, model, clustergt)
%try
    model.P(isnan(model.P))=0; model.Q(isnan(model.Q))=0;
    [model.P0, model.A, model.Q0] = lsqSolvePAQ(E, lsqA(E, model.P, model.Q), 10, model.P, model.Q, 0);
    %disp('mie');
    model.diffP=sqresidue(model.P, model.P0);
    model.diffQ=sqresidue(model.Q, model.Q0);
    model.mfcluster=clustering(model);
    %[e0 cov]=evaluateClustering([model.cluster; clustergt], 0);
    %model.eval_mie = mutualinfo(cov);
    %[e1 cov]=evaluateClustering([model.mfcluster; clustergt], 0);
    %model.eval_miemf = mutualinfo(cov);
    %model.eval = [e0 evaluateClustering([model.cluster; clustergt], 1) e1 evaluateClustering([model.mfcluster; clustergt], 1)];
    %model.e0me = evaluateClustering([model.cluster; clustergt], 0);
    %model.e0mf = evaluateClustering([model.mfcluster; clustergt], 0);
    %model.nmimf = nmi(model.mfcluster, clustergt);
    %model.nmime = nmi(model.cluster, clustergt);
%catch except
%    disp(except);
%end;