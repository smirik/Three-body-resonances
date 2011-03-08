program resonances
  implicit none
  
  character(len=200) :: a
  character(len=200) :: format
  
  ! result file
  open(7, file = 'result', access = 'append', status = 'new')
  
  ! JUPITER and SATURN files
  open(8, file = 'mercury/JUPITER.aei', status = 'old')
  open(9, file = 'mercury/SATURN.aei', status = 'old')
  
  write (7, *) 'COOL'
  
  read (8, '(a)', end=1) a,a,a,a

  format = "(10X, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7, ES14.7)"

  read (8, format) a,a,a,a,a,a,a,a,a
  
  write (*, *) a
  
  close(7)
  close(8)
  close(9)
  
1 continue
2 format(3f10.1,3f10.1,3f10.1,3f10.1,3f10.1,3f10.1,3f10.1,3f10.1,3f10.1)

end program resonances
