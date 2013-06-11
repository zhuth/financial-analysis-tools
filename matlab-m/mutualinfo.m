function mi = mutualinfo(A)
aa = A .* log(A ./ (sum(A')'*sum(A)));
aa(isnan(aa)) = 0;
mi = sum(sum(aa));