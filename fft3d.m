function Y = fft3d( nx,ny,nz, nvec, idirection, X)
% Y = fft3d( nx,ny,nz, nvec, idirection, X)
%
Fx = form_FT(nx, idirection );
Fy = form_FT(ny, idirection );
Fz = form_FT(nz, idirection );

Y = kronmult3( nz,nz, Fz, ...
	       ny,ny, Fy, ...
	       nx,nx, Fx, nvec, X );

end
