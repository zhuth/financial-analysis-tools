function X = normalize(X)
X = X * diag(1./sum(X));
X(isnan(X)) = 0;
