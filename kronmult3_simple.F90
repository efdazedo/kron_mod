      subroutine kronmult3_simple(nrow1,ncol1,A1,ldA1,                   &
     &                     nrow2,ncol2,A2,ldA2,                          &
     &                     nrow3,ncol3,A3,ldA3,                          &
     &                     nvec, X, Y )
      implicit none
      integer, value :: nrow1,ncol1,ldA1
      integer, value :: nrow2,ncol2,ldA2
      integer, value :: nrow3,ncol3,ldA3
      integer, value :: nvec

      complex*16, intent(in) :: A1(ldA1,ncol1)
      complex*16, intent(in) :: A2(ldA2,ncol2)
      complex*16, intent(in) :: A3(ldA3,ncol3)
      complex*16, intent(in) :: X(ncol3*ncol2*ncol1,nvec)
      complex*16, intent(inout) :: Y(nrow3*nrow2*nrow1,nvec)

      integer :: i1,i2,i3, j1,j2,j3
      integer :: i, ii,jj
      complex*16 :: yii, xjj, c_ii_jj
! -------------------------------------------------------------------
! Y([i3,i2,i1])=C([i3,i2,i1],[j3,j2,j1])=kron(A1,A2,A3)*X([j3,j2,j1])
! -------------------------------------------------------------------

#ifdef _OPENACC
!$acc kernels
!$acc loop independent gang vector collapse(4) private(ii,yii)
#elif OMP_TARGET
!$omp target teams
!$omp distribute  parallel simd collapse(4) private(ii,yii)
#else
!$omp parallel 
!$omp do collapse(4) private(ii,yii)
#endif
      do i=1,nvec
      do i1=1,nrow1
      do i2=1,nrow2
      do i3=1,nrow3

        ii = i3 + (i2-1)*nrow3 + (i1-1)*(nrow3*nrow2)
        yii = 0
        do j1=1,ncol1
        do j2=1,ncol2
        do j3=1,ncol3
          jj = j3 + (j2-1)*ncol3 + (j1-1)*(ncol3*ncol2)

          xjj = X(jj,i)
          c_ii_jj = A1(i1,j1)*A2(i2,j2)*A3(i3,j3)
          
          yii = yii + c_ii_jj * xjj
        enddo
        enddo
        enddo

        Y(ii,i) = yii

      enddo
      enddo
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
      end subroutine kronmult3_simple
