function [P A Q] = nnmf3(E, s, t)
[p1 p2] = nnmf(E, s);
[q1 q2] = nnmf(E, t);
P = p1 * diag(1./sum(p1));
Q = q2' * diag(1./sum(q2'));
P(isnan(P))=0; Q(isnan(Q))=0;
d1 = diag(sum(p1)); d2 = diag(sum(q2'));
if s < t,
    [r a1] = nnmf(q1 * d2, s);
else
    [a1 r] = nnmf(d1 * p2, t);
end;
A = a1 ./ sum(a1(:));