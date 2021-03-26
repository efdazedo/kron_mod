function W = form_FT( n, idirection )
% W = form_FT( n, idirection )
% form Fourier matrix for Fourier transform
%
% use matlab convention
%
% idirection ==  1, mean forward transform
% idirection == -1, mean backward transform
%
% Y(k) = sum( X(j) * Wn^{ (j-1)*(k-1) }
% X(j) = (1/n) * sum( Y(k) * Wn^{ -(j-1)*(k-1) }
%
% where Wn = exp( -(2*pi)/n )
%
W = zeros(n,n);
is_forward = (idirection == 1);
if (is_forward),
	theta = (-2*pi)/n;
else
	theta = (2*pi)/n;
end;

for j=1:n,
for k=1:n,
	theta_jk = theta * (j-1)*(k-1);
	W(k,j) = cos(theta_jk) + sqrt(-1)*sin(theta_jk);
end;
end;

if (is_forward),
  % ----------
  % do nothing
  % ----------
else
  % ------------------------------------
  % scale by (1/n) for matlab convention
  % ------------------------------------
  W(1:n,1:n) = W(1:n,1:n) * (1/n);
end;

end

