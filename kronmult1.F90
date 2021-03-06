       subroutine kronmult1( nrow1,ncol1,A1,ldA1,  nvec,X,Y)
       use prec_mod
       implicit none
!      ------------------
!      compute Y = A1 * X
!      ------------------
       integer, intent(in) :: nrow1, ncol1, nvec, ldA1

       ZTYPE, intent(in) :: A1(ldA1,ncol1)
       ZTYPE, intent(in) :: X(ncol1,nvec) 
       ZTYPE, intent(inout) :: Y(nrow1,nvec) 

       integer, parameter :: nb = 64
       integer :: istart,iend,isize
       integer :: jstart,jend,jsize
       integer :: mm,nn,kk,ld1,ld2,ld3
       ZTYPE, DIMENSION(2) :: alphabeta

          alphabeta(1) = 1 ! alpha
          alphabeta(2) = 0 ! beta
          mm = nrow1
          nn = nvec
          kk = ncol1
          ld1 = size(A1,1)
          ld2 = size(X,1)
          ld3 = size(Y,1)
#ifdef _OPENACC
!$acc  data pcopyin(A1,X) pcopyout(Y)                                      &
!$acc& pcopyin(alphabeta,mm,nn,kk,ld1,ld2,ld3)
#elif OMP_TARGET
!$omp target data map(to:A1,X) map(from:Y)                               &
!$omp& map(to:alphabeta,mm,nn,kk,ld1,ld2,ld3)
#endif



#ifdef _OPENACC
!$acc  kernels present(A1,X,Y)
!$acc  loop independent gang collapse(2)                                 &
!$acc& private(iend,jend,isize,jsize)
#elif OMP_TARGET
!$omp target teams
!$omp distribute collapse(2)                                              &
!$omp& private(iend,jend,isize,jsize)
#else
!$omp  parallel  do shared(A1,X,Y,mm,nn,kk,alphabeta,ld1,ld2,ld3)         &
!$omp& private(iend,jend,isize,jsize)
#endif
          do jstart=1,nn,nb
          do istart=1,mm,nb
             jend = min(nn,jstart+nb-1)
             iend = min(mm,istart+nb-1)
             isize = (iend-istart+1)
             jsize = (jend-jstart+1)
             
          call GEMM( 'N','N', isize,jsize,kk,                           &
     &      alphabeta(1), A1(istart,1),ld1, X(1,jstart), ld2,           &
     &      alphabeta(2),  Y(istart,jstart), ld3 )
          enddo
          enddo

#ifdef _OPENACC
!$acc end loop
!$acc end kernels
#elif OMP_TARGET
!$omp end target teams
#else
!$omp end parallel do
#endif


#ifdef _OPENACC
!$acc end data
#elif OMP_TARGET
!$omp end target data
#endif
       return
       end subroutine kronmult1



