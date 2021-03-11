      subroutine crandom(A)
      use prec_mod
      implicit none
      complex(kind=dp), intent(inout) :: A(:,:)

      integer :: j
      real(kind=dp) :: Ar(size(A,1))
      real(kind=dp) :: Ac(size(A,1))

      do j=1,size(A,2)
        call random_number(Ar)
        call random_number(Ac)
        Ar = 2*Ar - 1
        Ac = 2*Ac - 1
        A(:,j) = dcmplx(Ar,Ac)
      enddo 

      return
      end subroutine crandom
