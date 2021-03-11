      subroutine kronmult3(nrow1,ncol1,A1,ldA1,                          &
     &                     nrow2,ncol2,A2,ldA2,                          &
     &                     nrow3,ncol3,A3,ldA3,                          &
     &                     nvec, X, Y )
      implicit none
      integer, intent(in) :: nrow1,ncol1,ldA1
      integer, intent(in) :: nrow2,ncol2,ldA2
      integer, intent(in) :: nrow3,ncol3,ldA3
      integer, intent(in) :: nvec
      complex*16, intent(in) :: A1(ldA1,ncol1)
      complex*16, intent(in) :: A2(ldA2,ncol2)
      complex*16, intent(in) :: A3(ldA3,ncol3)
      complex*16, intent(in) :: X(ncol3*ncol2*ncol1,nvec)
      complex*16, intent(inout) :: Y(nrow3*nrow2*nrow1,nvec)

      integer :: i,nv
      integer :: mm,nn,kk,ld1,ld2,ld3
      complex*16 :: alpha, beta
      complex*16 :: W(ncol3*ncol2*nrow1,nvec)

! ---------------------------------------------
! for i=1:nvec
!   compute Wi = Xi * transpose(A1)
!   where Xi = reshape(X(:,i), [ncol3*ncol2, ncol1])
!       Wi = reshape(W(:,i), [ncol3*ncol2, nrow1])
! ---------------------------------------------
      do i=1,nvec
        mm = ncol3*ncol2
        nn = nrow1
        kk = ncol1
        alpha = 1
        beta = 0
        ld1 = ncol3*ncol2
        ld2 = ldA1
        ld3 = ncol3*ncol2
        call zgemm('N','T',mm,nn,kk,                                     &
     &         alpha, X(1,i),ld1, A1, ld2,                               &
     &         beta, W(1,i), ld3 )
      enddo

! ---------------------------
! compute Y = kron(A2,A3) * W
! ---------------------------
      nv = nvec * nrow1
      call kronmult2( nrow2, ncol2, A2, ldA2,                            &
     &                nrow3, ncol3, A3, ldA3,                            &
     &                nv,                                                &
     &                W, Y )
      return
      end subroutine kronmult3
