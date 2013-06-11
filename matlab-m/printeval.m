%
% 'diffp', 'diffq'
% 'e0me', 'e0mf', 'e1me', 'e2mf', 'fme', 'fmf'
function printeval(mcsc, show)
n = length(mcsc);
if ~iscell(show), show = {show}; end;
for si = 1 : length(show)
    fprintf('==== %s ====\n', show{si});
    fprintf('#\tlda\tplsa\trp\tkmeans\tnnmf\tnn3\n');
    for i = 1 : n
        mr = mcsc{i};
		if ischar(mr{1}), offset = 2; fprintf('%s', mr{1}); else fprintf('%d', i); offset = 1; end;
        for j = offset : length(mr)
            fprintf('\t');
            try
                eval([show{si} '(mr{j})']);
            catch
                fprintf('NA');
            end;
        end;
        fprintf('\n');
    end;
end;

function diffp(model)
fprintf('%d', model.diffP); 

function diffq(model)
fprintf('%d', model.diffQ);

function e0mf(model)
fprintf('%d', model.e0mf);

function e0me(model)
fprintf('%d', model.e0me);

function fme(model)
fprintf('%d', harmmean([1-model.eval(1), 1-model.eval(2)]));

function fmf(model)
fprintf('%d', harmmean([1-model.eval(3), 1-model.eval(4)]));

function mie(model)
fprintf('%d', mutualinfo(model.A));

function nmimf(model)
fprintf('%d', model.nmimf);

function nmime(model)
fprintf('%d', model.nmime);
