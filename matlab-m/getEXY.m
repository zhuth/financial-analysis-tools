function E = getEXY(X, Y, removeZero)
n = size(X, 1);
X = normalize(X')'; Y = normalize(Y')';
if (exist('removeZero') & removeZero==1)
    X(:, sum(X) == 0) = [];
    Y(:, sum(Y) == 0) = [];
else,
    removeZero = 0;
end;
E = zeros(size(X, 2), size(Y, 2));
if removeZero <= 1, removeZero = n; end;
for i = 1 : removeZero
    if removeZero >= n, di = i; else, di = mod(int32(rand*n) + 1,n) + 1; end;
    if mod(i, 100) == 0, fprintf('%d.', i); end;
    E = E + X(di, :)' * Y(di, :);
end;
E = E / n;