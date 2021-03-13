
touch test_kron_mod_acc
rm test_kron_mod_acc

nvfortran -DUSE_DOUBLE -cpp -E -F -UOMP_TARGET -D_OPENACC kron_mod.F90 > kron_mod.f90

echo "=== with -Minline ==== "
nvfortran -DUSE_DOUBLE  -Mstandard -Mfixed  \
	-acc=verystrict  -ta=tesla -Minfo=all \
	-Minline=size:99,reshape \
        -UOMP_TARGET \
	-c prec_mod.F90 kron_mod.f90  


echo "=== without -Minline ==== "
nvfortran -DUSE_DOUBLE  -Mstandard -Mfixed  \
	-acc=verystrict  -ta=tesla,keepgpu,keepptx  -Minfo=all \
        -UOMP_TARGET \
	-c prec_mod.F90 kron_mod.f90  


echo "=== link -Minline ==== "
nvfortran -DUSE_DOUBLE  -Mstandard -Mfixed  \
	-acc=verystrict  -ta=tesla,keepgpu,keepptx  -Minfo=all \
        -UOMP_TARGET \
	-o test_kron_mod_acc \
	 prec_mod.o kron_mod.o test_kron_mod.F90  
