function r = sqresidue(A, B)
D = A - B;
r = sum(D(:) .^ 2);