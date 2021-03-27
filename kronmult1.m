function Y = kronmult1( m1,n1, A1, nvec, X )
% Y = kronmult1( m1,n1, A1, nvec, X )
% implemented as single matrix multiply
%
Y(1:m1, 1:nvec)  = A1(1:m1,1:n1) * X(1:n1, 1:nvec);
end

