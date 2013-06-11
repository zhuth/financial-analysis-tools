%function A = lsqA(E, P, Q)
%A = pinv(P) * E * pinv(Q');


function A = lsqA(E, P, Q)
A=zeros(size(P,2),size(Q,2));
AQ=pinv(P)*E;
for i=1:size(A, 1),
    A(i,:)=lsqnonneg(Q,AQ(i,:)')';
end;
A=A./sum(A(:));
