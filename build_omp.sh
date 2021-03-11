

pgf90 -cpp -E -F -U_OPENACC -DOMP_TARGET kron_mod.F90 > kron_mod.f90
nvfortran -mp=gpu -ta=tesla,cc70  -Minfo=all \
	-U_OPENACC -DOMP_TARGET \
	-o test_kron_mod_omp \
	kron_mod.f90  test_kron_mod.F90 




