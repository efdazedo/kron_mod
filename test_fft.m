iforward = 1;
ibackward = -1;

nx = 32;
ny = 45;
nz = 60;
nvec = 1;

X2 = rand([nx,ny]) + sqrt(-1)*rand([nx,ny]);

Y2 = fft2( X2 );
iY2 = ifft2( Y2 );


Y2_kron = fft2d( nx,ny, nvec, iforward, X2 );
iY2_kron = fft2d( nx,ny, nvec, ibackward, Y2_kron );

disp(sprintf('norm(Y2-Y2_kron) %g ', ...
	max(abs(Y2(:)-Y2_kron(:))) ));
disp(sprintf('norm(iY2 - iY2_kron) %g ', ...
	max(abs(iY2(:) - iY2_kron(:))) ));


X3 = rand([nx,ny,nz]) + sqrt(-1)*rand([nx,ny,nz]);

Y3 = fftn( X3, [nx,ny,nz]);
iY3 = ifftn( Y3, [nx,ny,nz] );

Y3_kron = fft3d( nx,ny,nz, nvec, iforward, X3 );
iY3_kron = fft3d( nx,ny,nz, nvec, ibackward, Y3_kron);

disp(sprintf('norm(Y3-Y3_kron) %g ', ...
	max(abs(Y3(:)-Y3_kron(:)))  ));

disp(sprintf('norm(iY3-iY3_kron) %g', ...
	max(abs(iY3(:)-iY3_kron(:))) ));
