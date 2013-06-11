function A = mie_max(P, A, Q, E, step_len, max_iter)
if nargin < 5, step_len = 1e-3; end;
if nargin < 6, max_iter = 100; end;
for iter = 1 : max_iter
    Ax=pinv(P)*sum(E')'; Ay=pinv(Q)*sum(E)';
    As=Ax*Ay';
    lambda=log(sum(As(:)))-1;
    An=As*exp(-1-lambda);
    dA=An-A;
    nA1 = A - step_len * dA; nA1 = nA1 .* (nA1 > 0);
    nA2 = A + step_len * dA; nA2 = nA2 .* (nA2 > 0);
    m0 = mutualinfo(A);
    m1 = mutualinfo(nA1);
    m2 = mutualinfo(nA2);
    if ((m0 > m1) && (m0 > m2)), return; end;
    if (m1 > m2), A = nA1; else A = nA2; end;
end;