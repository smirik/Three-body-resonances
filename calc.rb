include Math
require 'complex'
require 'yaml'

class Numeric
  
  def to_deg()
    180.0*self/Math::PI
  end
  
  def from_deg()
    Math::PI*self/180.0
  end
  
end

def by_mod(l)
  if (l > Math::PI)
    while (l > Math::PI)
      l = l - Math::PI
    end
  else
    while (l < -Math::PI)
      l = l + Math::PI
    end
  end
  l
end


def mean_motion_from_axe(axe)
  mean_motion = Math.sqrt(0.0002959122082855911025 / (axe**3))
  mean_motion
end

def parse_str(s)
  datas = s.split(' ')
  time = datas[0]
  p_longitude  = datas[1].to_f
  mean_anomaly = datas[2].to_f
  semi_axe     = datas[3].to_f
  
  m_longitude  = p_longitude + mean_anomaly
  mean_motion  = mean_motion_from_axe(semi_axe).to_deg
  [time, m_longitude, p_longitude, mean_motion, semi_axe]
end  

def calc(filename, resonance)
  # open result file
  result_file = File.open('result', 'w+')

  #result_file.write('BODY: '+body['name']+"\n")
  j_filename = 'JUPITER.aei'
  s_filename = 'SATURN.aei'
  
  stdin   = File.open(filename)
  j_stdin = File.open(j_filename)
  s_stdin = File.open(s_filename)

  content   = Array.new
  j_content = Array.new
  s_content = Array.new

  stdin.each{|line| content.push(line)}
  j_stdin.each{|line| j_content.push(line)}
  s_stdin.each{|line| s_content.push(line)}

  len = content.length-1
  tmp = parse_str(content[4])
  axe_initial = tmp[4]
  #result_file.write("#axe = #{tmp[4]}, mean motion = #{tmp[3]}\n")
  #result_file.write(sprintf("%12s %12s %12s %12s %12s %12s\n", "time", "sigma", "s/m axe", "lambda_j", "lambda_s", "lambda"))
  
  for i in 4..len
    datas   = parse_str(content[i])    
    j_datas = parse_str(j_content[i])
    s_datas = parse_str(s_content[i])
    
    angle = resonance[0]*j_datas[1]+resonance[1]*s_datas[1]+resonance[2]*datas[1]
           +resonance[3]*j_datas[2]+resonance[4]*s_datas[2]+resonance[5]*datas[2]
    
    angle = angle.from_deg
    angle = by_mod(angle)
    
    z = Math::exp(Complex::I*angle)
    
    #ss = time.to_s+' '+m_longitude.to_s+' '+mean_motion.to_s+"\n"
    #ss = sprintf("%12f %12f %12f %12f %12f %12f\n", datas[0], angle, datas[4], j_datas[1], s_datas[1], datas[1])
    ss = sprintf("%6f %6f %6f %6f %6f\n", datas[0], angle, datas[4], z.real, z.image)
    result_file.write(ss)
  end

  result_file.close

end

objects = [ ['A982',  [3.0, -2.0, -1.0, 0, 0, 0.0]],
            ['A138',  [7.0, -2.0, -2.0, 0, 0, -3.0]],
            ['A463',  [4.0, -2.0, -1.0, 0, 0, -1.0]],
            ['A463B', [4.0, -3.0, -1.0, 0, 0, -0.0]],
            ['A463C', [4.0, -2.0, -2.0, 0, 0, -0.0]],
            ['A3',    [7.0, -4.0, -2.0, 0, 0, -1.0]]
          ]

objects.each do |elem|
  obj = elem[0]
  calc(obj+'.aei', elem[1])
  `gnuplot angle.gnu > png/angle#{obj}.png`
  `gnuplot axe.gnu > png/axe#{obj}.png`
  `gnuplot complex.gnu > png/complex#{obj}.png`
end
