subroutine squarize(x)
  implicit none
  real :: x
  
  x = x**2
end subroutine squarize

function square(x)
  square = x**2
end function
