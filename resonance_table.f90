! find axis by resonance (Nesvorny 1998, Gallardo 2006)
function count_axis(resonance, a_j, n_j, l_j, a_s, n_s, l_s, a_a, n_a, l_a)
  implicit none

  real :: a_j, n_j, l_j, a_s, n_s, l_s, a_a, n_a, l_a, eps
  real :: count_axis
  real :: a_from_n

  real, dimension(6) :: resonance
  
  real, parameter :: k = 0.017202098795, pi = 3.141592653589
  n_a = (-resonance(1)*n_j-resonance(2)*n_s-resonance(4)*l_j-resonance(5)*l_s)/resonance(3)
  if (n_a < 0) then
    count_axis = -1.0
  else
    a_a = a_from_n(n_a) ! formula for s/a
    eps = (a_j - a_a)/a_j
    l_a = k/(2*pi)*(a_a/a_j)**0.5*(eps**2)*n_j
    n_a = (-resonance(1)*n_j-resonance(2)*n_s-resonance(4)*l_j-resonance(5)*l_s-resonance(3)*l_a)/resonance(3)
    a_a = a_from_n(n_a) ! formula for s/a
    count_axis = a_a
  end if
end function count_axis