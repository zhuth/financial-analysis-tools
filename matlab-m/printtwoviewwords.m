function printtwoviewwords(P, A, Q, voc1, voc2, limit)
if nargin < 6,
    limit = 10;
end;
s = size(P, 2); t = size(Q, 2);
%I = A .* log(A ./ (sum(A')' * sum(A))); I(isnan(I))=0;
I = A;
[a p] = sort(I(:), 'descend');
pix = floor((p-1)/s) + 1;
piy = mod(p-1, s) + 1;
for i = 1 : min(length(pix), limit)
    fprintf('%d\t%d', I(p(i)), A(p(i)));
    printtwords(voc1, P(:, piy(i)), 10);
    fprintf('\t');
    printtwords(voc2, Q(:, pix(i)), 10);
    fprintf('\n');
end;

function printtwords(voc, prob, n)
[mv idx] = sort(prob, 'descend');
for i = 1 : n
    fprintf('\t%s\t%.3f', voc{idx(i)}, prob(idx(i)));
end;