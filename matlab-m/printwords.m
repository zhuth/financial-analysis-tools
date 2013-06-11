% print words
function printwords(voc, p, n)
for s = 1 : size(p, 2)
    [pv idx] = sort(p(:,s), 'descend');
    %fprintf('%d', s);
    for i = 1 : n
        if p(idx(i),s) <= eps, break; end;
        fprintf('\t%s(%.3f)', voc{idx(i)}, p(idx(i),s));
    end;
    if i > 1, fprintf('\\\\\n'); end;
end;