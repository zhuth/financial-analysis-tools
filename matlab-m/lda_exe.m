function [WZ, Z] = lda_exe(data, k, Wd, alpha)
if nargin < 3
    tmp_name = data;
else
    if (ischar(data))
        tmp_name = data;
    else
        path = 'D:\Documents\学校\作业\毕业设计\Tools\bin\';
        tmp_name = tempname;
        tmp_name = tmp_name(35:end);
        writeDoc([tmp_name '.txt'], data, Wd);
        args = [path 'lda.exe est ' num2str(alpha) ' ' int2str(k) ' ' path 'settings.txt ' tmp_name '.txt random ' tmp_name '\ > nul'];
        unix(args);
    end;
end;
beta = load([tmp_name '\final.beta']);
gamma = load([tmp_name '\final.gamma']);
Z = kmeans(gamma, k, 'emptyaction' ,'singleton')';
[mv Z] = max(gamma');
WZ = exp(beta);
WZ = WZ(:, 2:end)';

if size(WZ, 1) < size(data, 2),
    WZ = [WZ; zeros(size(data, 2) - size(WZ, 1), size(WZ, 2))];
end;

if (~ischar(data))
    unix(['del ' tmp_name '.txt > nul']);
    unix(['del /s /q ' tmp_name ' > nul']);
    unix(['rmdir ' tmp_name]);
end;

function writeDoc(filename, data, Wd)
f = fopen(filename, 'w');
for i = 1 : size(data, 1)
    fprintf(f, '%d', sum(data(i, :) ~= 0));
    for j = 1 : size(data, 2)
        if (data(i, j) ~= 0),
            fprintf(f, ' %d:%d', j, int32(data(i, j) * Wd));
        end;
    end;
    fprintf(f, '\n');
end;
fclose(f);
