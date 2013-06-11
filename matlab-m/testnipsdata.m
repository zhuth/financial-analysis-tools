load ../nipsdata/nips.doc-abs.mat
E = getEXY(data1, data2, 0);
runtest;
save nipsdata.result.mat