      program test_kron_mod
      use kron_mod
      implicit none

      integer :: nrow1,ncol1,ldA1
      integer :: nrow2,ncol2,ldA2
      integer :: nrow3,ncol3,ldA3
      integer :: nvec

      complex*16, allocatable :: X(:,:), Y(:,:), Y_simple(:,:)
      complex*16, allocatable :: A1(:,:)
      complex*16, allocatable :: A2(:,:)
      complex*16, allocatable :: A3(:,:)
      real*8 :: max_err

      nrow1 = 5
      ncol1 = 6
      nrow2 = 7
      ncol2 = 8
      nrow3 = 9
      ncol3 = 10
      nvec = 11

      ldA1 = nrow1
      ldA2 = nrow2
      ldA3 = nrow3
      allocate( A1(ldA1,ncol1) )
      allocate( A2(ldA2,ncol2) )
      allocate( A3(ldA3,ncol3) )

      allocate( X(ncol3*ncol2*ncol1,nvec) )
      allocate( Y(nrow3*nrow2*nrow1,nvec) )
      allocate( Y_simple(nrow3*nrow2*nrow1,nvec) )

      call crandom(X)
      call crandom(A1)
      call crandom(A2)
      call crandom(A3)

      Y(:,:) = 0
      Y_simple(:,:) = 0

#ifdef _OPENACC
!$acc data copyin(X) copyout(Y,Y_simple)
#elif OMP_TARGET
!$omp target data map(to:X) map(from:Y,Y_simple)
#endif

      call kronmult3(nrow1,ncol1,A1,ldA1, &
     &               nrow2,ncol2,A2,ldA2, &
     &               nrow3,ncol3,A3,ldA3, &
     &               nvec, X, Y )

      call kronmult3_simple(nrow1,ncol1,A1,ldA1, &
     &                      nrow2,ncol2,A2,ldA2, &
     &                      nrow3,ncol3,A3,ldA3, &
     &                      nvec, X, Y_simple )

#ifdef _OPENACC
!$acc end data 
#elif OMP_TARGET
!$omp end target data 
#endif

! -------------
! check results
! -------------
       max_err = maxval( abs(Y - Y_simple) )
       print*,'max_err = ', max_err
       stop
       end program test_kron_mod


