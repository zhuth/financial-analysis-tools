if ~exist('toyset'), disp('Error: please specify toy set.'); return; end;
toysetcases = dir([toyset '\*.mat']); toysettestcasecount = 1;
for ii = 1 : length(toysetcases)
    load([toyset '\' toysetcases(ii).name]);
    runtest;
    testresult{toysettestcasecount} = {toysetcases(ii).name lda pl rp km nn nn3}; toysettestcasecount = toysettestcasecount + 1;
end;
