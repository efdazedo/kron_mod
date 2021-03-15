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


echo "=== OpenACC complex ==== "
touch kron_mod.i; rm kron_mod.i
ftn -eP -F -UUSE_DOUBLE -D_OPENACC kron_mod.F90 ; cp kron_mod.i kron_mod.f90
ftn -h acc -h noomp   \
   -UUSE_DOUBLE \
	-o test_kron_mod_acc_complex \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 

echo "=== OpenACC double ==== "
touch kron_mod.i; rm kron_mod.i
ftn -eP -F -DUSE_DOUBLE -D_OPENACC kron_mod.F90 ; cp kron_mod.i kron_mod.f90
ftn -h acc -h noomp   \
   -DUSE_DOUBLE \
	-o test_kron_mod_acc_double \
	prec_mod.F90 kron_mod.f90  test_kron_mod.F90 

