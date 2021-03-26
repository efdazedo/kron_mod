function Y = fft2d( nx, ny, nvec, idirection, X )
% Y = fft2d( nx, ny, nvec, idirection, X )
% 2D FFT
%
Fy = form_FT( ny, idirection );
Fx = form_FT( nx, idirection );

Y = kronmult2( ny,ny,Fy, nx,nx,Fx, nvec, X );

end
