function y = rndprj(x, k)
rp = rand(size(x, 2), k);
rp = normalize(rp);
y = x * rp;