      subroutine kronmult2( nrow1,ncol1,A1,ldA1,                         &
     &                      nrow2,ncol2,A2,ldA2,                         &
     &                      nvec,                                        &
     &                      X,Y ) 
! ---------------------------------------------------------
! compute vec(Y(:,1:nvec)) = kron(A1,A2) * vec(X(:,1:nvec))
! for each i
!    Yi = A2 * Xi * transpose(A1)
! ---------------------------------------------------------
      use prec_mod
      implicit none
      integer, intent(in) :: nrow1,ncol1,ldA1
      integer, intent(in) :: nrow2,ncol2,ldA2
      integer, intent(in) :: nvec

      ZTYPE, intent(in) :: A1(ldA1,ncol1)
      ZTYPE, intent(in) :: A2(ldA2,ncol2)
      ZTYPE, intent(in) :: X(ncol2*ncol1,nvec)
      ZTYPE, intent(inout) :: Y(nrow2*nrow1,nvec)

      ZTYPE :: W( ncol2*nrow1, nvec )

      integer :: i, nv
      integer :: mm,nn,kk,ld1,ld2,ld3
      ZTYPE :: alpha,beta

! -------------------------------
! perform Wi = Xi * transpose(A1)
! Xi = reshape( X(:,i), [ncol2,ncol1])
! Wi = reshape( W(:,i), [ncol2,nrow1])
! -------------------------------
         mm = ncol2
         nn = nrow1
         kk = ncol1
         ld1 = mm
         ld2 = ldA1
         ld3 = mm
         alpha = 1
         beta = 0

#ifdef _OPENACC
!$acc data pcopyin(A1,A2,X) create(W) pcopyout(Y)                        &
!$acc& copyin(mm,nn,kk,ld1,ld2,ld3,alpha,beta)
#elif OMP_TARGET
!$omp target data map(to:A1,A2,X) map(alloc:W) map(from:Y)               &
!$omp& map(to:mm,nn,kk,ld1,ld2,ld3,alpha,beta)
#endif




#ifdef _OPENACC
!$acc kernels present(A1,X,W)
!$acc loop gang                                                           
#elif OMP_TARGET
!$omp target teams 
!$omp distribute                                                          
#else
!$omp  parallel  shared(A1,X,W)                                         &
!$omp& firstprivate(mm,nn,kk,ld1,ld2,ld3,alpha,beta)
!$omp do                                                          
#endif
      do i=1,nvec
         call GEMM( 'N', 'T', mm,nn,kk,                                  &
     &     alpha, X(1,i), ld1, A1, ld2,                                  &
     &     beta, W(1,i), ld3 )
      enddo
#ifdef _OPENACC
!$acc end kernels
#elif OMP_TARGET
!$omp end target teams
#else
!$omp end parallel
#endif

!  ----------------------
!  Y(1:nrow2,1:nv) = kronmult1( A2(1:nrow2,1:ncol2), W(1:ncol2,1:nv))
!  ----------------------
      nv = nvec * nrow1
      call kronmult1( nrow2, ncol2, A2, ldA2,                            &
     &         nv, W, Y )



#ifdef _OPENACC
!$acc end data
#elif OMP_TARGET
!$omp end target data
#endif
      return
      end subroutine kronmult2
