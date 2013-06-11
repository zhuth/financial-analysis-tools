mcsc={}; tcount = 1;
for tcase = 1 : 20
    load(['..\toydata3\' num2str(0) '_' num2str(tcase)]);
    runtest;
    mcsc{tcount} = {lda pl rp km nn nn3};
    tcount = tcount + 1;
end;
for cor = 0.1 : 0.1 : 0.9;
    eval = [];
    fprintf('>>> cor = %d\n', cor);
    for tcase = 1 : 20
        load(['..\toydata3\' num2str(cor) '_' num2str(tcase)], '-mat');
        runtest;
        mcsc{tcount} = {lda pl rp km nn nn3};
        tcount = tcount + 1;
    end;
end;