! from radians to degrees
function to_deg(num)
  real (kind=8) :: num, to_deg
  write (*, *) num
  to_deg = 180.0*num/3.141592653589
end function to_deg

! from degrees to radians
function from_deg(num)
  real (kind=8) :: num, from_deg
  from_deg = 3.141592653589*num/180.0
end function from_deg

! cut by module
subroutine by_mod(num)
  real (kind=8) :: num, pi
  integer i
  
  pi = 3.141592653589
  
  do
    if ((num >= -pi) .and. (num <= pi)) then
      exit
    else
      if (num <= -pi) then
        num = num + 2.0*pi
      endif
      if (num >= pi) then
        num = num - 2.0*pi
      endif
    endif
  end do
    
end subroutine by_mod

function mean_motion_from_axis(axis)
  real (kind=8) :: mean_motion_from_axis, axis, k2
  k2 = 0.0002959122082855911025
  mean_motion_from_axis = sqrt(k2 / (axis**3))
end function mean_motion_from_axis