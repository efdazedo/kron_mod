       subroutine kronmult1( nrow1,ncol1,A1,ldA1,  nvec,X,Y)
#ifdef _OPENACC
!$acc routine worker
#else
!$omp declare target
#endif
       implicit none
!      ------------------
!      compute Y = A1 * X
!      ------------------
       integer, intent(in) :: nrow1, ncol1, nvec, ldA1
       complex*16, intent(in) :: A1(ldA1,ncol1)
       complex*16, intent(in) :: X(ncol1,nvec) 
       complex*16, intent(inout) :: Y(nrow1,nvec) 

       integer :: mm,nn,kk,ld1,ld2,ld3
       complex*16 :: alpha, beta

          beta = 0
          alpha = 1
          mm = nrow1
          nn = nvec
          kk = ncol1
          ld1 = size(A1,1)
          ld2 = size(X,1)
          ld3 = size(Y,1)
          call zgemm( 'N','N', mm,nn,kk,                                 &
     &      alpha, A1,ld1, X, ld2,                                       &
     &      beta,  Y, ld3 )

       return
       end subroutine kronmult1



