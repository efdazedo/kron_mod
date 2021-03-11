

pgf90 -cpp -E -F -DOMP_TARGET -U_OPENACC kron_mod.F90 > kron_mod.f90

#  echo "=== with -Minline ==== "
#  nvfortran -Mstandard -Mfixed  \
#  	-mp=gpu  -ta=tesla,cc70 -Minfo=all \
#  	-Minline=name:zgemm,reshape \
#  	-c prec_mod.F90 kron_mod.f90  


echo "=== without -Minline ==== "
nvfortran -Mstandard -Mfixed  \
	-mp=gpu  -gpu=cc70 -Minfo=all \
	-c prec_mod.F90 kron_mod.f90  

echo "== compile driver == "
nvfortran -Mstandard -Mfixed  \
	-mp=gpu  -gpu=cc70 -Minfo=all \
	-c test_kron_mod.F90

echo "== link step == "
nvfortran -Mstandard -Mfixed  \
	-mp=gpu  -gpu=cc70 -Minfo=all \
	-o test_kron_mod_omp \
	 prec_mod.o kron_mod.o  test_kron_mod.o


