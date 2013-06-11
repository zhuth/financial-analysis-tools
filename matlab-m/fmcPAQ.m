function [P, A, Q] = fmcPAQ(E, s, t)
[p, q] = size(E);
x = zeros(1,s*t+p*s+q*t);
Aeq = sparse(s+t+1, s*t+p*s+q*t);
for i = 1 : s
    Aeq(i, (i-1)*p+(1:p)) = 1;
end;
for i = 1 : t
    Aeq(i+s, p*s+s*t+(i-1)*q+(1:q)) = 1;
end;
Aeq(s+t+1, p*s+(1:s*t)) = 1;
beq = ones(s+t+1,1);
x = fmincon(@(x)myfr(x, p, q, s, t, E), x, [], [], Aeq, beq, zeros(size(x)), ones(size(x)), [], optimset('GradConstr','on'));
P = reshape(x(1:p*s),[p s]);
A = reshape(x(p*s+(1:s*t)), [s t]);
Q = reshape(x(p*s+s*t+(1:q*t)), [q t]);

function [R, grad] = myfr(x, p, q, s, t, E)
P = reshape(x(1:p*s),[p s]);
A = reshape(x(p*s+(1:s*t)), [s t]);
Q = reshape(x(p*s+s*t+(1:q*t)), [q t]);
R = abs(P*A*Q'-E); R = sum(R(:));
dP = sum(Q*A'); dQ = sum(P*A);
dA = zeros(size(A));
for k = 1 : s
    for l = 1 : t
        tmp = 0;
        for i = 1 : p
            for j = 1 : q
                tmp = tmp + P(i, k) * Q(j, l);
            end;
        end;
        dA(k, l) = tmp;
    end;
end;
grad = [dP(:); dA(:); dQ(:)];