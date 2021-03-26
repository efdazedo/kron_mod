function Y = fft1d( n, nvec, idirection, X )
% Y = fft1d( n, idirection, X )

X = reshape( X, [n,nvec]);
Fx = zeros(n,n);

Fx = form_FT(n, idirection );
Y = kronmult1( n,n,Fx, nvec, X );

end
