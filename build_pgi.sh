pgf90 -cpp -E -F kron_mod.F90 > kron_mod.f90
nvfortran -Mbounds -g -o test_kron_mod_serial \
	kron_mod.f90  test_kron_mod.F90 -lblas


pgf90 -cpp -E -F -D_OPENACC kron_mod.F90 > kron_mod.f90
nvfortran -acc -ta=tesla,cc70  -Minfo=all \
	-o test_kron_mod_acc \
	kron_mod.f90  test_kron_mod.F90 




