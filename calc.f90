program resonances
  use strings
  implicit none
  
  character(len=200) :: a
  character(len=200) :: format
  real, dimension(9) :: data_j, data_s, data_a ! data from file for Jupiter, Saturn and the asteroid
  real, dimension(5) :: c_data_j, c_data_s, c_data_a ! corrected data from file for Jupiter, Saturn and the asteroid
  real, dimension(6) :: resonance ! array of resonance parameters
  real :: tmp, tmp2
  character(len=20) :: asteroid_name ! for asteroid naming
  integer :: i,j

  ! define the resonance
  resonance = (/ 5, -2, -2, 0, 0, 1 /)
  asteroid_name = 'mercury/A138.aei'
  
  ! result file
  open(7, file = 'result', access = 'append', status = 'new')
  
  ! JUPITER and SATURN files
  open(8, file = 'mercury/JUPITER.aei', status = 'old')
  open(9, file = 'mercury/SATURN.aei', status = 'old')
  open(10, file = asteroid_name, status = 'old')
  
  write (7, *) 'COOL'
  
  read (8, '(a)', end=1) a,a,a,a
  read (9, '(a)', end=1) a,a,a,a
  read (10, '(a)', end=1) a,a,a,a

  !format = "(10X, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7)"

  ! 1 — time, 2 — p_longitude, 2 — mean anomaly, 3 — semimajor axis
  do i=1,10
    read (8, *) data_j(1),data_j(2),data_j(3),data_j(4),data_j(5),data_j(6),data_j(7),data_j(8),data_j(9)
    read (9, *) data_s(1),data_s(2),data_s(3),data_s(4),data_s(5),data_s(6),data_s(7),data_s(8),data_s(9)
    read (10, *) data_a(1),data_a(2),data_a(3),data_a(4),data_a(5),data_a(6),data_a(7),data_a(8),data_a(9)

    ! count resonant argument

    write (*, *) data_j
    write (*, *) data_s
    write (*, *) data_a
  end do
  
  close(7)
  close(8)
  close(9)
  
1 continue

end program resonances
