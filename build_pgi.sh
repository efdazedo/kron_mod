echo "=== serial complex == "
pgf90 -cpp -E -F kron_mod.F90 > kron_mod.f90
pgf90 -Mbounds -g -o test_kron_mod_serial_complex \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 -lblas

echo "=== serial double == "
pgf90 -cpp -E -F -DUSE_DOUBLE kron_mod.F90 > kron_mod.f90
pgf90 -Mbounds -g \
   -o test_kron_mod_serial_double \
   -DUSE_DOUBLE \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 -lblas


echo "=== OpenACC noinline complex ==== "
pgf90 -cpp -E -F -D_OPENACC kron_mod.F90 > kron_mod.f90
pgf90 -acc=verystrict  -ta=tesla,cc70  -Minfo=all \
	-o test_kron_mod_acc_complex \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 

echo "=== OpenACC noinline double ==== "
pgf90 -cpp -E -F -DUSE_DOUBLE -D_OPENACC kron_mod.F90 > kron_mod.f90
pgf90 -acc=verystrict  -ta=tesla,cc70  -Minfo=all \
   -DUSE_DOUBLE \
	-o test_kron_mod_acc_double \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 

echo "=== OpenACC with inline complex ==== "
pgf90 -cpp -E -F  -D_OPENACC kron_mod.F90 > kron_mod.f90
pgf90 -acc=verystrict  -ta=tesla,cc70  -Minfo=all \
    -Minline=size:99,reshape \
	-o test_kron_mod_acc_complex \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 


echo "=== OpenACC with inline double ==== "
pgf90 -cpp -E -F  -DUSE_DOUBLE -D_OPENACC kron_mod.F90 > kron_mod.f90
pgf90 -acc=verystrict  -ta=tesla,cc70  -Minfo=all \
    -Minline=size:99,reshape \
    -DUSE_DOUBLE \
	-o test_kron_mod_acc_inline_double \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 
