module load xl cuda essl
touch prec_mod.mod 
rm *.mod *.o

xlf90_r  -d -qfixed=72 -qlist -qattr=full -qsmp=omp -qoffload \
  -WF,-qfpp=linecont \
  -DOMP_TARGET -U_OPENACC -c \
  prec_mod.F90 

xlf90_r  -d -qfixed=72 -qlist -qattr=full -qsmp=omp -qoffload \
  -WF,-qfpp=linecont \
  -DOMP_TARGET -U_OPENACC -c \
  kron_mod.F90 


touch test_kron_mod_omp
rm test_kron_mod_omp

xlf90_r  -d -qfixed=72 -qlist -qattr=full -qsmp=omp -qoffload \
  -WF,-qfpp=linecont \
  -DOMP_TARGET -U_OPENACC \
  prec_mod.o kron_mod.o test_kron_mod.F90 \
  -o test_kron_mod_omp \
  -L $OLCF_ESSL_ROOT/lib64 -lessl

