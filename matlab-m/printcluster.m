function printcluster(cluster, names)
count = 1;
for i = min(cluster) : max(cluster)
    nn=names(cluster == i);
    if (length(nn) <= 0), continue; end;
    fprintf('%d', count);
    for j = 1 : length(nn)
        fprintf('\t%s', nn{j});
    end;
    count = count + 1;
    disp(' ');
end;
disp(' ');