! get semimajor axis from mean motion
! n — mean motion of object
function parse_data_string (s)
  character(len=100) :: s

  real, parameter :: k = 0.017202098795
  real :: a, n
  
!   datas = s.split(' ')
!   time = datas[0]
!   p_longitude  = datas[1].to_f
!   mean_anomaly = datas[2].to_f
!   semi_axe     = datas[3].to_f
!   
!   m_longitude  = p_longitude + mean_anomaly
!   mean_motion  = mean_motion_from_axe(semi_axe).to_deg
!   [time, m_longitude, p_longitude, mean_motion, semi_axe]
!   
!   
  parse_data_string = 1.0
end function parse_data_string

function calc_resonance_argument(data_j, data_s, data_)

end function calc_resonance_argument

! data: 1 — time, 2 — longitude of perihelium, 3 — mean anomaly, 4 — semimajor axis
function calc_resonance_parameters(data)
  real, dimension(5) :: calc_resonance_parameters
  real, dimension(5) :: c_data ! 1 — time, 2 — mean longitude, 3 — longitude of perihelium, 4 — mean motion, 5 — s/m axis
  
  c_data(1) = data(1)
  c_data(2) = data(2) + data(3)
  c_data(3) = data(2)
  c_data(4) = n_from_a(data(4))
  c_data(5) = data(4)
  
  calc_resonance_parameters = c_data
  
end function calc_resonance_parameters