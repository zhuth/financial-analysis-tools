% test stock data
diary off;
!del diary
diary on;

data1 = importdata(file1);
data2 = importdata(file2);

% clustergt
if size(data1, 1) == 50,
    clustergt = [repmat(1,[1 10]) repmat(2,[1 10]) repmat(3,[1 10]) repmat(4,[1 10]) repmat(5,[1 10])];
else
    clustergt = ones(1, size(data1, 1));
    data2(:, sum(data2)==0)=[];
    tmp = (data2(:, 2:end)-data2(:, 1:end-1))./data2(:, 1:end-1);
    data2 = zeros(size(data2, 1), 2*size(data2, 2)-2);
    data2(:, 1:2:end) = round(tmp * 100 .* (tmp > 0));
    data2(:, 2:2:end) = round(tmp * -100 .* (tmp < 0));
    data2(isnan(data2))=0; data2(isinf(data2))=0;
end;

E = getEXY(data1, data2, 0);
n = size(data1, 1);

if ~exist('s'), s = 5; end;
if ~exist('t'), t = 5; end;

disp('init');
lda.s = s; lda.t = t; lda.eval = [];
[lda.P, lda.cluster1] = lda_exe(data1, lda.s, 1, 50/s);
[lda.Q, lda.cluster2] = mixGuassAnalysis(data2, lda.t)
lda.data1 = data1; lda.data2 = data2;
lda.cluster = lda.cluster1 * lda.t + lda.cluster2;
lda = runtestfunc(E, lda);

models = {lda};
for i = 1 : length(models)
    m = models{i};
    fprintf('******\n');
    try 
        fprintf('cluster1\n');
        printcluster(m.cluster1, names);
    catch
    end;
    try
        fprintf('cluster2\n');
        printcluster(m.cluster2, names);
    catch
    end;
    try
        fprintf('cluster-mixed\n');
        printcluster(m.mfcluster, names);
    catch
    end;
end;

printeval({{lda, pl, rp, km, nn ,nn3}}, 'fmf')

diary off;
!notepad diary
