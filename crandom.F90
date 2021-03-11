      subroutine crandom(A)
      implicit none
      complex*16, intent(inout) :: A(:,:)

      integer :: j
      real*8 :: Ar(size(A,1))
      real*8 :: Ac(size(A,1))

      do j=1,size(A,2)
        call random_number(Ar)
        call random_number(Ac)
        Ar = 2*Ar - 1
        Ac = 2*Ac - 1
        A(:,j) = dcmplx(Ar,Ac)
      enddo 

      return
      end subroutine crandom
