       subroutine kronmult1( nrow1,ncol1,A1,ldA1,  nvec,X,Y)
       use prec_mod
       implicit none
!      ------------------
!      compute Y = A1 * X
!      ------------------
       integer, value :: nrow1, ncol1, nvec, ldA1

       complex(kind=dp), intent(in) :: A1(ldA1,ncol1)
       complex(kind=dp), intent(in) :: X(ncol1,nvec) 
       complex(kind=dp), intent(inout) :: Y(nrow1,nvec) 

       integer, parameter :: nb = 64
       integer :: istart,iend,isize
       integer :: jstart,jend,jsize
       integer :: mm,nn,kk,ld1,ld2,ld3
       complex(kind=dp) :: alpha, beta

          beta = 0
          alpha = 1
          mm = nrow1
          nn = nvec
          kk = ncol1
          ld1 = size(A1,1)
          ld2 = size(X,1)
          ld3 = size(Y,1)
#ifdef _OPENACC
!$acc  data copyin(A1,X) copyout(Y)                                      &
!$acc& copyin(alpha,beta,mm,nn,kk,ld1,ld2,ld3)
#elif OMP_TARGET
!$omp target data map(to:A1,X) map(from:Y)                               &
!$omp& map(to:alpha,beta,mm,nn,kk,ld1,ld2,ld3)
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
!$omp  parallel  
!$omp  do shared(A1,X,Y,mm,nn,kk,alpha,beta,ld1,ld2,ld3)  &
!$omp& private(iend,jend,isize,jsize)
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


#ifdef _OPENACC
!$acc end data
#elif OMP_TARGET
!$omp end target data
#endif
       return
       end subroutine kronmult1



