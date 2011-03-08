program test
  
  ! special type resonance
  type :: resonance
    integer :: len
    real :: value
  end type resonance

! all types
  integer :: i,j,k
  real :: axe, tmp, sum
  complex :: ci
  logical :: flag
  character(len=80) :: ss
  
  ! resonance type
  type(resonance) :: res
  
  ! sample of array
  real, dimension(3) :: array
  ! sample of non dimensional array
  real, dimension(:), allocatable :: arr
  
  ss = "Hello world!"
  print *, ss
  ! string from 1 to 3 symbols
  print *, ss(1:3)
  
  ! array output
  array(1) = 1.1
  array(2) = 1.2
  array(3) = 1.3
  
  print *, array
  
  ! resonance type variable
  
  res%len = 5
  print *, res
  
  ! check logical variables
  flag = (array(1) == 1.1) .AND. (array(2) == 1.2)
  print *, "FLAG = ", flag
  
  ! if then elseif else
  if ( (array(1) == 1.0) ) then
    print *, "CASE 1"
  else if ( array(1) == 1.1 ) then
    print *, "CASE 2"
  else
    print *, "OTHER"
  end if
    
  ! input
  !read *, i
  !print *, "i = ", i
  
  ! loop sample
  sum = 0.0
  do i = 1,3
    sum = sum + array(i)
    ! exit from loop
    if (i == 2) then
      exit
    end if
  end do
  
  print *, "СУММА = ", sum
  print *, "КВАДРАТ = ", square(sum)
  print *, "СУММА ЕЩЁ РАЗ = ", sum
  call squarize(sum)
  print *, "КВАДРАТ routine = ", sum
  
  k = nfactorial(5)
  print *, "ФАКТОРИАЛ 5 = ", k
  
  ! nondimensional array arr
  allocate ( arr(10) )
  k = size(arr)
  print *, "РАЗМЕР МАССИВА = ", k
  do i = 1,10
    arr(i) = i
  end do
  print *, arr
  deallocate(arr)
  
end program