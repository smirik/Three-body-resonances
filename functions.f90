subroutine squarize(x)
  implicit none
  real :: x
  
  x = x**2
end subroutine squarize

function square(x)
  square = x**2
end function

recursive function nfactorial(n) result (fac) 
  ! computes the factorial of n (n!)
  integer :: fac
  integer, intent(in) :: n
  
  fac = 0.0
  select case (n) 
    case (0:1)
      fac = 1 
    case default
      fac = n * nfactorial (n-1) 
  end select
end function nfactorial