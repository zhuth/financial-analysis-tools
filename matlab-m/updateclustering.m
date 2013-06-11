n = length(mcsc);
fprintf('#\tlda\tplsa\trp\tkmeans\tnnmf\tnn3\n');
for i = 1 : n
    mr = mcsc{i};
    fprintf('%d', i);
    for j = 1 : length(mr)
        fprintf('\t');
        try
            mr{j}.eval = [evaluateClustering([mr{j}.cluster; clustergt], 0) evaluateClustering([mr{j}.cluster; clustergt], 1) evaluateClustering([clustering(mr{j}); clustergt], 0)  evaluateClustering([clustering(mr{j}); clustergt], 1)];
            fprintf('.');
        catch
            fprintf('NA');
        end;
    end;
    fprintf('\n');
end;
