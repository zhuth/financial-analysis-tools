function v = bsdvalid(list, dir)
for i = 1 : length(list)
    f = [dir list{i} '.bsd'];
    v(i) = exist(f);
end;
v = v > 0;