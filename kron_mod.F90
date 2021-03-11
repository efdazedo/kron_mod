      module kron_mod
      implicit none
#if defined(_OPENACC) || defined(OMP_TARGET)
#else
      interface
      subroutine zgemm(transA,transB,m,n,k,alpha,A,lda,B,ldb,beta,C,ldc)
      implicit none
      character transA,transB
      integer m,n,k,lda,ldb,ldc
      complex*16 alpha, beta
      complex*16 A(lda,*),B(ldb,*),C(ldc,*)
      end subroutine zgemm
      end interface
#endif
      contains
#if defined(_OPENACC) || defined(OMP_TARGET)
#include "zgemm_acc.F90
#endif
#include "crandom.F90"
#include "kronmult1.F90"
#include "kronmult2.F90"
#include "kronmult3.F90"
#include "kronmult3_simple.F90"
      end module kron_mod

