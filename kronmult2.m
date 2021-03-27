function Y = kronmult2(m1,n1,A1,  m2,n2,A2, nvec, X )
% Y = kronmult2(m1,n1,A1,  m2,n2,A2, nvec, X )
%
% Y = kron(A1,A2)*X
% implemented as 
% Y = A2 * X * transpose(A1)
% step 1: W = X * transpose(A1)
% step 2: Y = A2 * W
% -----------
X = reshape( X, [n2*n1, nvec] );

use_W = 1;
if (use_W),
  % ---------------------------------
  % use more temporary work space in W
  % larger new_nvec call to kronmult1
  % ---------------------------------
  W = zeros( n2*m1, nvec );
  for i=1:nvec,
	Xi = reshape(X(:,i), [n2,n1]);
	Wi = Xi(1:n2, 1:n1) * transpose( A1(1:m1,1:n1) );
	W(1:(n2*m1), i) = reshape( Wi, [n2*m1,1]);
  end;

  % ------------------------------
  % larger single call to kronmult
  % ------------------------------
  new_nvec = nvec * m1;
  W = reshape( W, [n2, new_nvec]);
  Y = zeros( [m2, new_nvec]);
  Y(1:m2,1:new_nvec) = kronmult1( m2,n2,A2, new_nvec, W );
  Y = reshape( Y, [m2*m1, nvec] );
else
  % -----------------------------------
  % use less temporary work space in Wi
  % more calls matrix multiply
  % -----------------------------------
  Y = zeros( m2*m1,  nvec );
  for i=1:nvec,
	Xi = reshape(X(:,i), [n2,n1]);
	Wi = Xi(1:n2, 1:n1) * transpose( A1(1:m1,1:n1) );
	new_nvec = m1;
	Yi = kronmult1( m2,n2,A2,  new_nvec, Wi);
	Y(1:(m2*m1),i) = reshape( Yi, [m2*m1,1]);
  end 
end;


end


