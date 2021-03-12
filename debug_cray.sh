echo " == serial == "
ftn -h noacc -h noomp -o test_kron_mod_serial \
	prec_mod.F90 kron_mod.F90 test_kron_mod.F90

echo "== OpenACC == "
ftn -h acc -h noomp -target-accel=amd_gfx906 \
	-o test_kron_mod_acc \
	prec_mod.F90 kron_mod.F90 test_kron_mod.F90

echo "== OpenMP == "
ftn -eZ -hlist=a -h noacc -h omp -DOMP_TARGET -target-accel=amd_gfx906 \
	-o test_kron_mod_omp \
	prec_mod.F90 kron_mod.F90 test_kron_mod.F90
