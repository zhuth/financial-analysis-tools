clc;
n = length(lda1);
A = nn.A;
for i = 1 : n
    mc1(i, :) = data1(i, :) * log(nn.P0 + eps);
    mc2(i, :) = data2(i, :) * log(nn.Q0 + eps);
end;
[p c1] = max(mc1'); [p c2] = max(mc2');
I=log(A./(sum(A')'*sum(A))); I(isnan(I))=0;
I=A;
for i = 1 : n
    ILDA(i) = I(lda1(i), lda2(i));
end;
[p ilc]=sort(ILDA);
for i = 1 : 10
    fprintf('%d\t%s', ILDA(ilc(i)), docs{ilc(i)});
    fprintf('\n\t%d ', c1(ilc(i)));
    printwords(voc_doc, nn.P0(:, c1(ilc(i))), 20);
    fprintf('\t%d ', c2(ilc(i)));
    printwords(voc_abs, nn.Q0(:, c2(ilc(i))), 20);
end;