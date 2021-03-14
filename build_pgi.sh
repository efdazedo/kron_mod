echo "=== serial == "
pgf90 -cpp -E -F kron_mod.F90 > kron_mod.f90
pgf90 -Mbounds -g -o test_kron_mod_serial \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 -lblas


echo "=== OpenACC noinline complex ==== "
pgf90 -cpp -E -F -D_OPENACC kron_mod.F90 > kron_mod.f90
pgf90 -acc -ta=tesla,cc70  -Minfo=all \
	-o test_kron_mod_acc \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 

echo "=== OpenACC noinline double ==== "
pgf90 -cpp -E -F -DUSE_DOUBLE -D_OPENACC kron_mod.F90 > kron_mod.f90
pgf90 -acc -ta=tesla,cc70  -Minfo=all \
   -DUSE_DOUBLE \
	-o test_kron_mod_acc_double \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 

echo "=== OpenACC with inline complex ==== "
pgf90 -cpp -E -F  -D_OPENACC kron_mod.F90 > kron_mod.f90
pgf90 -acc -ta=tesla,cc70  -Minfo=all \
    -Minline=size:99,reshape \
	-o test_kron_mod_acc \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 


echo "=== OpenACC with inline double ==== "
pgf90 -cpp -E -F  -DUSE_DOUBLE -D_OPENACC kron_mod.F90 > kron_mod.f90
pgf90 -acc -ta=tesla,cc70  -Minfo=all \
    -Minline=size:99,reshape \
    -DUSE_DOUBLE \
	-o test_kron_mod_acc_inline_double \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 
