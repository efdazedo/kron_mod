

pgf90 -cpp -E -F -D_OPENACC kron_mod.F90 > kron_mod.f90

# echo "=== with -Minline ==== "
# nvfortran -Mstandard -Mfixed  \
# 	-acc -ta=tesla,cc70,nollvm  -Minfo=all \
# 	-Minline=name:zgemm,reshape \
# 	-c prec_mod.F90 kron_mod.f90  


echo "=== without -Minline ==== "
nvfortran -Mstandard -Mfixed  \
	-acc -ta=tesla,cc70,keepgpu,keepptx  -Minfo=all \
	-c prec_mod.F90 kron_mod.f90  


echo "=== link -Minline ==== "
nvfortran -Mstandard -Mfixed  \
	-acc -ta=tesla,cc70,keepgpu,keepptx  -Minfo=all \
	-o test_kron_mod_acc \
	 prec_mod.o kron_mod.o test_kron_mod.F90  
