m1 = 3; n1 = 4; A1 = rand(m1,n1);
m2 = 5; n2 = 6; A2 = rand(m2,n2);
m3 = 7; n3 = 8; A3 = rand(m3,n3);

nvec = 2;

X1 = rand(n1,nvec);
Y1_exact = A1(1:m1,1:n1) * X1;
Y1 = kronmult1( m1,n1,A1, nvec, X1 );
err1 = max(abs(Y1(:)-Y1_exact(:)));
disp(sprintf('err1 = %g ', err1 ));


X2 = rand( (n2*n1), nvec );
Y2_exact = kron(A1,A2) * X2;
Y2 = kronmult2( m1,n1,A1, m2,n2,A2, nvec, X2 );
err2 = max(abs(Y2(:) - Y2_exact(:)));
disp(sprintf('err2 = %g ', err2 ));

X3 = rand( (n3*n2*n1), nvec );
Y3_exact = kron( kron(A1,A2), A3) * X3;
Y3 = kronmult3( m1,n1,A1, m2,n2,A2, m3,n3,A3, nvec, X3 );
err3 = max( abs(Y3(:) - Y3_exact(:)) );
disp(sprintf('err3 = %g ', err3 ));



