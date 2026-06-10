! RUN: %not_todo_cmd bbc -fopenacc -emit-hlfir %s -o - 2>&1 | FileCheck %s

subroutine test_unstructured2(a, b, c)
  integer :: i, j, k
  real :: a(:,:,:), b(:,:,:), c(:,:,:)

  !$acc parallel loop
  do i = 1, 10
    do j = 1, 10
      do k = 1, 10
        if (a(1,2,3) > 10) stop 'just to be unstructured'
      end do
    end do
  end do

end subroutine

subroutine test_unstructured_collapse_cycle(a)
  integer :: i, j, jdiag
  real(8) :: a(:,:)
  jdiag = 4
  !$acc parallel loop collapse(2) copy(a)
  do j = 1, 8
    do i = 1, 8
      if (i == jdiag) then
        a(i, j) = 0.0d0
        cycle
      end if
      a(i, j) = real(i + j, 8)
    end do
  end do
  !$acc end parallel loop
end subroutine

subroutine test_unstructured_collapse_stop(a)
  integer :: i, j, k
  real :: a(:,:,:)
  !$acc parallel loop collapse(3)
  do i = 1, 10
    do j = 1, 10
      do k = 1, 10
        if (a(1,2,3) > 10) stop 'just to be unstructured'
      end do
    end do
  end do
end subroutine

! CHECK: not yet implemented: unstructured do loop in combined acc construct
