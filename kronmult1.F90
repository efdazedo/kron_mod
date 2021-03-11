       subroutine kronmult1( nrow1,ncol1,A1,ldA1,  nvec,X,Y)
       implicit none
!      ------------------
!      compute Y = A1 * X
!      ------------------
       integer, value :: nrow1, ncol1, nvec, ldA1

       complex*16, intent(in) :: A1(ldA1,ncol1)
       complex*16, intent(in) :: X(ncol1,nvec) 
       complex*16, intent(inout) :: Y(nrow1,nvec) 

       integer, parameter :: nb = 64
       integer :: istart,iend,isize
       integer :: jstart,jend,jsize
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
#ifdef _OPENACC
!$acc kernels
!$acc loop gang collapse(2) private(iend,jend,isize,jsize)
#elif OMP_TARGET
!$omp target teams
!$omp distribute collapse(2) private(iend,jend,isize,jsize)
#else
!$omp parallel 
!$omp do private(iend,jend,isize,jsize)
#endif
          do jstart=1,nn,nb
          do istart=1,mm,nb
             jend = min(nn,jstart+nb-1)
             iend = min(mm,istart+nb-1)
             isize = (iend-istart+1)
             jsize = (jend-jstart+1)
             
          call zgemm( 'N','N', isize,jsize,kk,                           &
     &      alpha, A1(istart,1),ld1, X(1,jstart), ld2,                   &
     &      beta,  Y(istart,jstart), ld3 )
          enddo
          enddo

#ifdef _OPENACC
!$acc end kernels
#elif OMP_TARGET
!$omp end target teams
#else
!$omp end parallel
#endif


       return
       end subroutine kronmult1



