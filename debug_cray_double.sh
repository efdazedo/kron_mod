echo " == serial == "
ftn -DUSE_DOUBLE  -M7256  -h noacc -h noomp -o test_kron_mod_serial \
	prec_mod.F90 kron_mod.F90 test_kron_mod.F90

echo "== OpenACC == "
ftn -DUSE_DOUBLE  -M7256  -h acc -h noomp  \
	-o test_kron_mod_acc \
	prec_mod.F90 kron_mod.F90 test_kron_mod.F90

echo "== OpenMP == "
ftn -DUSE_DOUBLE  -M7256  -eZ -hlist=a -h noacc -h omp -DOMP_TARGET  \
	-o test_kron_mod_omp \
	prec_mod.F90 kron_mod.F90 test_kron_mod.F90
