# kron_mod
Fortran files with OpenACC and OpenMP directives to perform 3D Kronecker Products.

This is a simple code to check the capability of OpenACC and OpenMP compilers,
in their support for  complex arithmetic and calling device subroutines  within OpenACC "gang" loop,
or within OpenMP "target teams distribute" loop. 

The device subroutines may have other OpenACC "loop vector"  or OpenMP "parallel do simd" 
directives.
