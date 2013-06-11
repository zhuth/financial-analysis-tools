% eval model
function [pdd bsd model] = evalm(data, model)
model.bsd_eval = pevalc(data, model.bsd);
model.pdd_eval = pevalc(data, model.pdd);
bsd.acc = evaluateClustering([reshape(model.bsd, 1, length(model.bsd)); model.labels']);
pdd.acc = evaluateClustering([reshape(model.bsd, 1, length(model.pdd)); model.labels']);
bsd.nmi = evaluateClustering(model.bsd, model.labels);
pdd.nmi = evaluateClustering(model.pdd, model.labels);
bsd.cor = mean(abs(model.bsd_eval(~isnan(model.bsd_eval))));
bsd.corstd = std(abs(model.bsd_eval(~isnan(model.bsd_eval))));
pdd.cor = mean(abs(model.pdd_eval(~isnan(model.pdd_eval))));
pdd.corstd = std(abs(model.pdd_eval(~isnan(model.pdd_eval))));
disp([bsd.acc,bsd.nmi,bsd.cor,bsd.corstd,pdd.acc,pdd.nmi,pdd.cor,pdd.corstd]');