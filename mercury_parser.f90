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
