function [fe nouse] = evaluateClustering(clusters, nouse)
if all(clusters==1), fe=0; return; end;
s = max(clusters(1, :)); t = max(clusters(2, :));
co = zeros(s, t);
for i = 1 : s
    for j = 1 : t
        co(i, j) = sum(clusters(1, :) == i & clusters(2, :) == j);
    end;
end;
fe = sum(max(co')) / length(clusters(1, :));