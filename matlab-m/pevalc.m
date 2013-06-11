function [cor] = pevalc(data, cluster)
uc = unique(cluster);
for c = 1 : length(uc)
    dc = data(cluster == uc(c), :);
    n = size(dc, 1);
    pcc = 0; cora = 0;
    for i = 1 : n
        for j = (i + 1) : n
            pcc = pcc + 1;
            cora = cora + corr2(dc(i, :), dc(j, :));
        end;
    end;
    cor(c) = cora / pcc;
end;
disp(mean(abs(cor(~isnan(cor)))));