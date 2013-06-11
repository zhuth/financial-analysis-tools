par = [];
par.Nd = 1000;
par.Wdn = 200;
par.Wd = 100;
par.small = 1e-2;
par.s = 20; par.t = 10;
s = par.s; t = par.t;
mcsc={}; tcount = 1;
for Wu = 100 : 100 : 1000;
    eval = [];
    fprintf('>>> Wu = %d\n', Wu);
    par.Wu = Wu;
    %[data1, data2, E, clustergt] = maketoydata(par);
    for tcase = 1 : 20
        load(['..\toydata\' num2str(Wu) '_' num2str(tcase)]);
        clear noplsa nokm nolda norp nonn nonn3
        runtest;
        mcsc{tcount} = {lda pl rp km nn nn3};
        tcount = tcount + 1;
    end;
end;