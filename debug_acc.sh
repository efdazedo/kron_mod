

pgf90 -cpp -E -F -UOMP_TARGET -D_OPENACC kron_mod.F90 > kron_mod.f90

echo "=== with -Minline ==== "
nvfortran -Mstandard -Mfixed  \
	-acc -ta=tesla,cc70,nollvm  -Minfo=all \
	-Minline=name:zgemm,reshape \
        -UOMP_TARGET \
	-c prec_mod.F90 kron_mod.f90  


echo "=== without -Minline ==== "
nvfortran -Mstandard -Mfixed  \
	-acc -ta=tesla,cc70,keepgpu,keepptx  -Minfo=all \
        -UOMP_TARGET \
	-c prec_mod.F90 kron_mod.f90  


echo "=== link -Minline ==== "
nvfortran -Mstandard -Mfixed  \
	-acc -ta=tesla,cc70,keepgpu,keepptx  -Minfo=all \
        -UOMP_TARGET \
	-o test_kron_mod_acc \
	 prec_mod.o kron_mod.o test_kron_mod.F90  
