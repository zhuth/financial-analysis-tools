function [count f] = distinctValues(arr)
minm = min(arr(:)); maxm = max(arr(:));
f = zeros(maxm - minm + 1 , 1);
for i = minm : maxm
    f(i - minm + 1) = any(arr(:) == i);
end;
count = sum(f);