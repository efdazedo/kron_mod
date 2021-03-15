#include "common.h"
      subroutine GEMM(transA,transB, m,n,kk,                            &
     &   alpha,A,lda,B,ldb,beta,C,ldc)
      use prec_mod
      implicit none
#ifdef _OPENACC
!$acc routine vector
#else
!$omp declare target  
#endif
      integer, intent(in) :: m,n,kk,lda,ldb,ldc
      ZTYPE, intent(in) :: alpha,beta
      character, intent(in) :: transA, transB

      ZTYPE, intent(in) :: A(lda,*)
      ZTYPE, intent(in) :: B(ldb,*)
      ZTYPE, intent(inout) :: C(ldc,*)

      integer, parameter :: nb = 64
      integer :: i,j,k
      ZTYPE :: cij, aik, bkj
      logical :: is_Aconj,is_Atrans,is_AN,no_transA
      logical :: is_Bconj,is_Btrans,is_BN,no_transB

      is_Aconj = (transA.eq.'C').or.(transA.eq.'c')
      is_Bconj = (transB.eq.'C').or.(transB.eq.'c')
      is_Atrans = (transA.eq.'T').or.(transA.eq.'t')
      is_Btrans = (transB.eq.'T').or.(transB.eq.'t')

      is_AN = (transA.eq.'N').or.(transA.eq.'n')
      is_BN = (transB.eq.'N').or.(transB.eq.'n')

      no_transA = is_AN .or. (.not.(is_Aconj.or.is_Atrans))
      no_transB = is_BN .or. (.not.(is_Bconj.or.is_Btrans))





#ifdef _OPENACC
!$acc loop vector collapse(2) private(cij,aik,bkj,k)
#else
!$omp parallel do simd collapse(2) private(cij,aik,bkj,k)
#endif
      do j=1,n
      do i=1,m

        cij = 0
        do k=1,kk
          if (no_transA) then
            aik = A(i,k)
          else
            if (is_Aconj) then
                    aik = conjg(A(k,i))
            else
                    aik = A(k,i)
            endif
          endif

          if (no_transB) then
            bkj = B(k,j)
          else
            if (is_Bconj) then
                    bkj = conjg(B(j,k))
            else
                    bkj = B(j,k)
            endif
          endif

          cij = cij + aik * bkj
         enddo

         if (beta.eq.0) then
          C(i,j) = alpha * cij
         else
          C(i,j) = beta*C(i,j) + alpha * cij
         endif

       enddo
       enddo


       return
       end subroutine GEMM
