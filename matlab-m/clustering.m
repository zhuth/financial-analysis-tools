%% test clustering
function cluster = clustering(model, E)
n = size(model.data1, 1);
cluster = zeros(1, n);
model.P0(isnan(model.P0)) = 0;
model.Q0(isnan(model.Q0)) = 0;
pp = pinv(model.P0); qq = pinv(model.Q0);
if nargin == 2
    a = pp * E * qq';
end;
for i = 1 : n
    %aa = pp * model.data1(i, :)' * model.data2(i, :) * qq';
    %aa = lsqA(model.data1(i, :)' * model.data2(i, :), model.P0, model.Q0);
    aa = log(model.P0 + eps)' * model.data1(i, :)';
    bb = log(model.Q0 + eps)' * model.data2(i, :)';
    for s = 1 : length(aa)
        for t = 1 : length(bb)
            prob(s, t) = aa(s) + bb(t);
        end;
    end;
    aa = prob + log(model.A + eps);
    %if nargin == 2
    %    aa = aa(:) .* (a(:) ~= 0);
    %end;
    [mv cluster(i)] = max(aa(:));
end;