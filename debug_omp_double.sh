
touch test_kron_mod_omp
rm test_kron_mod_omp

nvfortran -DUSE_DOUBLE -cpp -E -F -DOMP_TARGET -U_OPENACC kron_mod.F90 > kron_mod.f90

echo "=== with -Minline ==== "
nvfortran -DUSE_DOUBLE  -Mstandard -Mfixed  \
	-mp=gpu -gpu=cc70  -Minfo=all \
	-Minline=size:99,reshape \
        -DOMP_TARGET -U_OPENACC \
	-c prec_mod.F90 kron_mod.f90  


echo "=== without -Minline ==== "
nvfortran -DUSE_DOUBLE  -Mstandard -Mfixed  \
	-mp=gpu -gpu=cc70  -Minfo=all \
        -DOMP_TARGET -U_OPENACC \
	-c prec_mod.F90 kron_mod.f90  


echo "=== link -Minline ==== "
nvfortran -DUSE_DOUBLE  -Mstandard -Mfixed  \
	-mp=gpu -gpu=cc70  -Minfo=all \
        -DOMP_TARGET -U_OPENACC \
	-o test_kron_mod_omp \
	 prec_mod.o kron_mod.o test_kron_mod.F90  
