function [P A Q] = lsqSolvePAQ(E, A, max_iters, P, Q, mie)
if (length(A) == 2), A = zeros(A); end;
if nargin < 6, mie = 0; end;
s = size(A, 1); t = size(A, 2);
if ((nargout < 3) | (all(size(P) == size(Q)) & all(P == Q)))
    if (nargin < 4)
        P = rand(size(E, 1), s);
    end;
    if (max_iters < 3), max_iters = 3; end;
    for i = 1 : (max_iters - 2)
        pinvP = pinv(P);
        A = pinvP * E * pinvP'; A = A ./ sum(A(:));
        P = (pinv(P * A) * E)';
        P = E * pinv(A * P');
    end;
    for i = 1 : 2
        A = lsqA(E, P, P);
        %A = (A + A'); A = A ./ sum(A(:));
        P = lsqQ(E, A, P);
        P = lsqP(E, A, P);
    end;
else
    if (max_iters == 0),
        A = lsqA(E, P, Q);
        return;
    end;
    sqrs = zeros(1, max_iters);
    for i = 1 : max_iters        
        A = lsqA(E, P, Q);
        % mie 
        if mie, A = mie_max(P, A, Q, E); end;
        P = lsqP(E, A, Q);
        Q = lsqQ(E, A, P);
        sqrs(i) = sqresidue(P*A*Q', E);
        if (i > 1), 
            %fprintf('%f', sqrs(i) - sqrs(i-1));
            if abs(sqrs(i)-sqrs(i-1)) < eps
                break;
            end;
        end;
    end;
end;

function P = lsqP(E, A, Q)
AQ = A * Q';
P = zeros(size(E, 1), size(A, 1));
for i=1:size(P,1),
    P(i, :) = lsqnonneg(AQ', E(i, :)')';
end;
P=normalize(P);

function Q = lsqQ(E, A, P)
AP = P * A;
Q = zeros(size(E, 2), size(A, 2));
for i=1:size(Q,1),
    Q(i, :) = lsqnonneg(AP, E(:, i));
end;
Q=normalize(Q);