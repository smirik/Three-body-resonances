! test mean motion for axis with given true value of n in true_n
! n_error — maximum error
function test_mean_motion_from_axis(axis, true_n, n_error)
  implicit none
  ! result
  real (kind = 8) test_mean_motion_from_axis
  !dummy
  real (kind = 8), intent(in) :: axis, true_n, n_error
  ! local
  real (kind = 8) :: n, mean_motion_from_axis

  n = mean_motion_from_axis(axis)
  if ((abs(n-true_n)) > n_error) then
    write (*, *) '[fail] mean_motion_from_axis failed with axis = 2.0'
    write (*, *) '        ', n, 'instead of ', true_n, ', delta = ', abs(n-true_n)
  else
    write (*, *) '[pass] mean_motion_from_axis for axis = 2.0', ', delta = ', abs(n-true_n), n_error
  end if
  test_mean_motion_from_axis = 1.0
end function test_mean_motion_from_axis

program astro_tests
  implicit none

  real (kind = 8) :: n1, n2, axis, mean_motion_from_axis, test_mean_motion_from_axis, n_error
  ! checking functions from astro.f90
  
  ! mean motion from 2 = 0.00608186040909349, 1.4 = 0.0103845907984668
  ! test mean motions
  n_error = 0.00000001
  axis = 2.0
  n1 = 0.00608186040909349
  n1 = test_mean_motion_from_axis(axis, n1, n_error)
  axis = 1.4
  n1 = 0.0103845907984668
  n1 = test_mean_motion_from_axis(axis, n1, n_error)
  
end program