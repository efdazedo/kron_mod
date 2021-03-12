      subroutine kronmult3(nrow1,ncol1,A1,ldA1,                          &
     &                     nrow2,ncol2,A2,ldA2,                          &
     &                     nrow3,ncol3,A3,ldA3,                          &
     &                     nvec, X, Y )
      use prec_mod
      implicit none
      integer, value :: nrow1,ncol1,ldA1
      integer, value :: nrow2,ncol2,ldA2
      integer, value :: nrow3,ncol3,ldA3
      integer, value :: nvec

      ZTYPE, intent(in) :: A1(ldA1,ncol1)
      ZTYPE, intent(in) :: A2(ldA2,ncol2)
      ZTYPE, intent(in) :: A3(ldA3,ncol3)
      ZTYPE, intent(in) :: X(ncol3*ncol2*ncol1,nvec)
      ZTYPE, intent(inout) :: Y(nrow3*nrow2*nrow1,nvec)

      integer :: i,nv
      integer :: mm,nn,kk,ld1,ld2,ld3
      ZTYPE :: alpha, beta
      ZTYPE :: W(ncol3*ncol2*nrow1,nvec)

! ---------------------------------------------
! for i=1:nvec
!   compute Wi = Xi * transpose(A1)
!   where Xi = reshape(X(:,i), [ncol3*ncol2, ncol1])
!       Wi = reshape(W(:,i), [ncol3*ncol2, nrow1])
! ---------------------------------------------

#ifdef _OPENACC
!$acc data pcopyin(A1,A2,A3,X)  pcopyout(Y) create(W)
#elif OMP_TARGET
!$omp target data map(to:A1,A2,A3,X) map(from:Y) map(alloc:W)
#endif



#ifdef _OPENACC
!$acc kernels present(X,A1,W)
!$acc loop gang                                                          &
!$acc& private(mm,nn,kk,alpha,beta,ld1,ld2,ld3)
#elif OMP_TARGET
!$omp target teams 
!$omp distribute                                                         &
!$omp& private(mm,nn,kk,alpha,beta,ld1,ld2,ld3)
#else
!$omp parallel 
!$omp do                                                        &
!$omp& private(mm,nn,kk,alpha,beta,ld1,ld2,ld3)
#endif
      do i=1,nvec
        mm = ncol3*ncol2
        nn = nrow1
        kk = ncol1
        alpha = 1
        beta = 0
        ld1 = mm
        ld2 = ldA1
        ld3 = mm
        call GEMM('N','T',mm,nn,kk,                                     &
     &         alpha, X(1,i),ld1, A1, ld2,                               &
     &         beta, W(1,i), ld3 )
      enddo
#ifdef _OPENACC
!$acc end kernels
#elif OMP_TARGET
!$omp end target teams
#else
!$omp end parallel
#endif

! ---------------------------
! compute Y = kron(A2,A3) * W
! ---------------------------
      nv = nvec * nrow1
      call kronmult2( nrow2, ncol2, A2, ldA2,                            &
     &                nrow3, ncol3, A3, ldA3,                            &
     &                nv,                                                &
     &                W, Y )

#ifdef _OPENACC
!$acc end data
#elif OMP_TARGET
!$omp end target data 
#endif
      return
      end subroutine kronmult3
