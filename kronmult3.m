function Y = kronmult3(m1,n1,A1,  m2,n2,A2, m3,n3,A3, nvec, X )
% Y = kronmult3(m1,n1,A1,  m2,n2,A2, m3,n3,A3, nvec, X )
%
% Y = kron(A2,A3)*X * transpose(A1)
% step 1: W = X * transpose(A1)
% step 2: Y = kron(A2,A3)*W

X = reshape( X, [n3*n2*n1, nvec]);
for i=1:nvec,
	Xi = reshape( X(1:(n3*n2*n1),i), [n3*n2, n1]);
	Wi = Xi(1:(n3*n2),1:n1)  * transpose( A1(1:m1,1:n1) );
	Wi = reshape( Wi, [n3*n2, m1]);
	new_nvec = m1;
	Y(1:(m3*m2*m1),i) = ...
	  reshape(kronmult2( m2,n2,A2,m3,n3,A3,new_nvec,Wi),[m3*m2*m1,1]);
end

end
