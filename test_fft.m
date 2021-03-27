iforward = 1;
ibackward = -1;

nx = 60;
ny = 27;
nz = 96;
nvec = 20;

X1 = rand([nx,nvec]);
Y1 = fft( X1 );
iY1 = ifft( Y1 );

Y1_kron = fft1d( nx, nvec, iforward, X1 );
iY1_kron = fft1d( nx, nvec, ibackward, Y1_kron);
disp(sprintf('norm(Y1-Y1_kron) %g ', ...
	    max(abs(Y1(:)-Y1_kron(:)))  ));

disp(sprintf('norm(iY1-iY1_kron) %g ', ...
	    max(abs(iY1(:)-iY1_kron(:) ))  ));

X2 = rand([nx,ny,nvec]) + sqrt(-1)*rand([nx,ny,nvec]);

Y2 = fft2( X2 );
iY2 = ifft2( Y2 );


Y2_kron = fft2d( nx,ny, nvec, iforward, X2 );
iY2_kron = fft2d( nx,ny, nvec, ibackward, Y2_kron );

disp(sprintf('norm(Y2-Y2_kron) %g ', ...
	max(abs(Y2(:)-Y2_kron(:))) ));
disp(sprintf('norm(iY2 - iY2_kron) %g ', ...
	max(abs(iY2(:) - iY2_kron(:))) ));


X3 = rand([nx,ny,nz,nvec]) + sqrt(-1)*rand([nx,ny,nz,nvec]);

Y3 = zeros( size(X3) );
iY3 = zeros( size(Y3) );
for i=1:nvec,
  Y3(1:nx,1:ny,1:nz,i) = fftn( X3(1:nx,1:ny,1:nz,i), [nx,ny,nz]);
  iY3(1:nx,1:ny,1:nz,i) = ifftn( Y3(1:nx,1:ny,1:nz,i), [nx,ny,nz] );
end;
Y3_kron = fft3d( nx,ny,nz, nvec, iforward, X3 );
iY3_kron = fft3d( nx,ny,nz, nvec, ibackward, Y3_kron);

disp(sprintf('norm(Y3-Y3_kron) %g ', ...
	max(abs(Y3(:)-Y3_kron(:)))  ));

disp(sprintf('norm(iY3-iY3_kron) %g', ...
	max(abs(iY3(:)-iY3_kron(:))) ));
