      subroutine kronmult2( nrow1,ncol1,A1,ldA1,                         &
     &                      nrow2,ncol2,A2,ldA2,                         &
     &                      nvec,                                        &
     &                      X,Y ) 
! ---------------------------------------------------------
! compute vec(Y(:,1:nvec)) = kron(A1,A2) * vec(X(:,1:nvec))
! for each i
!    Yi = A2 * Xi * transpose(A1)
! ---------------------------------------------------------
      implicit none
      integer, intent(in) :: nrow1,ncol1,ldA1
      integer, intent(in) :: nrow2,ncol2,ldA2
      integer, intent(in) :: nvec
      complex*16, intent(in) :: A1(ldA1,ncol1)
      complex*16, intent(in) :: A2(ldA2,ncol2)
      complex*16, intent(in) :: X(ncol2*ncol1,nvec)
      complex*16, intent(inout) :: Y(nrow2*nrow1,nvec)

      complex*16 :: W( ncol2*nrow1, nvec )

      integer :: i, nv
      integer :: mm,nn,kk,ld1,ld2,ld3
      complex*16 :: alpha,beta

! -------------------------------
! perform Wi = Xi * transpose(A1)
! Xi = reshape( X(:,i), [ncol2,ncol1])
! Wi = reshape( W(:,i), [ncol2,nrow1])
! -------------------------------

      do i=1,nvec
         mm = ncol2
         nn = nrow1
         kk = ncol1
         ld1 = mm
         ld2 = ldA1
         ld3 = mm
         alpha = 1
         beta = 0
         call zgemm( 'N', 'T', mm,nn,kk,                                 &
     &     alpha, X(1,i), ld1, A1, ld2,                                  &
     &     beta, W(1,i), ld3 )
      enddo

!  ----------------------
!  Y(1:nrow2,1:nv) = kronmult1( A2(1:nrow2,1:ncol2), W(1:ncol2,1:nv))
!  ----------------------
      nv = nvec * nrow1
      call kronmult1( nrow2, ncol2, A2, ldA2,                            &
     &         nv, W, Y )

      return
      end subroutine kronmult2
