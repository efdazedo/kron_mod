function Y = kronmult2(m1,n1,A1,  m2,n2,A2, nvec, X )
% Y = kronmult2(m1,n1,A1,  m2,n2,A2, nvec, X )
%
% Y = kron(A1,A2)*X
% implemented as 
% Y = A2 * X * transpose(A1)
% step 1: W = X * transpose(A1)
% step 2: Y = A2 * W

X = reshape( X, n2*n1, nvec );
for i=1:nvec,
	Xi = reshape(X(:,i), [n2,n1]);
	Wi = Xi(1:n2, 1:n1) * transpose( A1(1:m1,1:n1) );
	Y(1:(m2*m1),i) = reshape( A2(1:m2,1:n2) * Wi(1:n2,1:m1),   m2*m1, 1);
end 


