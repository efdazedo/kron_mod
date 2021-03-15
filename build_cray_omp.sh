echo "=== serial complex == "
touch kron_mod.i; rm kron_mod.i
ftn -eP -F kron_mod.F90 ; cp kron_mod.i kron_mod.f90
ftn  -F -o test_kron_mod_serial_complex \
	-h noacc -h noomp \
   -UUSE_DOUBLE \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 

echo "=== serial double == "
touch kron_mod.i; rm kron_mod.i
ftn -eP -F -DUSE_DOUBLE kron_mod.F90 ; cp kron_mod.i kron_mod.f90
ftn -F   \
   -DUSE_DOUBLE \
   -h noacc -h noomp \
   -o test_kron_mod_serial_double \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 


echo "=== OpenMP complex ==== "
touch kron_mod.i; rm kron_mod.i
ftn -eP -F -UUSE_DOUBLE -D_OPENACC kron_mod.F90 ; cp kron_mod.i kron_mod.f90
ftn  -h noacc -h omp   -DOMP_TARGET \
   -UUSE_DOUBLE \
	-o test_kron_mod_omp_complex \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 

echo "=== OpenMP double ==== "
touch kron_mod.i; rm kron_mod.i
ftn  -eP -F -DUSE_DOUBLE -D_OPENACC kron_mod.F90 ; cp kron_mod.i kron_mod.f90
ftn -h noacc -h omp   -DOMP_TARGET \
   -h list=ae \
   -DUSE_DOUBLE \
	-o test_kron_mod_omp_double \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 

