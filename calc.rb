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
      l = l - 2*Math::PI
    end
  else
    while (l < -Math::PI)
      l = l + 2*Math::PI
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
  p_longitude  = datas[1].to_f.from_deg
  mean_anomaly = datas[2].to_f.from_deg
  semi_axe     = datas[3].to_f
  ecc          = datas[4].to_f

  m_longitude  = p_longitude + mean_anomaly
  mean_motion  = mean_motion_from_axe(semi_axe)
  [time, m_longitude, p_longitude, mean_motion, semi_axe, ecc]
end  

def calc(filename, resonance, obj)
  # open result file
  result_file   = File.open('result', 'w+')
  result_file_p = File.open('output/res/'+obj+'.res', 'w+')

  #result_file.write('BODY: '+body['name']+"\n")
  j_filename = 'mercury/JUPITER.aei'
  s_filename = 'mercury/SATURN.aei'
  
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

  medium_angle = 0
  medium_time = 0
  counter = 0
  previous = Array.new
  
  previous = Array.new
  for i in 4..len
    counter+=1
    datas   = parse_str(content[i])    
    j_datas = parse_str(j_content[i])
    s_datas = parse_str(s_content[i])
    
    angle = resonance[0]*j_datas[1]+resonance[1]*s_datas[1]+resonance[2]*datas[1]+resonance[3]*j_datas[2]+resonance[4]*s_datas[2]+resonance[5]*datas[2]
    
    #angle = angle.to_deg
    angle = by_mod(angle)
    
    z = Math::exp(Complex::I*angle)
    
    #ss = time.to_s+' '+m_longitude.to_s+' '+mean_motion.to_s+"\n"
    ss = sprintf("%12f %12f %12f %12f %12f %12f %12f\n", datas[0], angle, datas[4], datas[5], j_datas[1], s_datas[1], datas[1])
    result_file.write(ss)
    result_file_p.write(ss)

    if false
    if (counter < 20)
      previous.push(angle)
    else
      #ss = sprintf("%6f %6f %6f %6f %6f\n", datas[0], angle, datas[4], z.real, z.image)
      previous.push(angle)
      medium_value = by_mod(previous.inject(0){|res, elem| res+elem}/20.0)
      previous.delete_at(0)
      
      #ss = sprintf("%6f %6f %6f\n", medium_time/10.0, medium_angle/10.0, datas[4])
      ss = sprintf("%6f %6f %6f\n", datas[0], medium_value, datas[4])
      result_file.write(ss)
      result_file_p.write(ss)
      
      medium_value = 0
    end
    end
  
  end

  result_file.close
  result_file_p.close

end

puts mean_motion_from_axe(2.0)
puts 3.0.to_deg
puts 100.from_deg
raise

objects = [ ['A982',   [3.0, -2.0, -1.0, 0, 0, 0.0]],
            ['A138',   [7.0, -2.0, -2.0, 0, 0, -3.0]],
            ['A463',   [4.0, -2.0, -1.0, 0, 0, -1.0]],
            ['A3',     [7.0, -4.0, -2.0, 0, 0, -1.0]],
            ['A3460',  [5.0, -2.0, -2.0, 0, 0, -1.0]],
            ['A3460B', [5.0, -3.0, -1.0, 0, 0, -1.0]],
            ['A10',    [8.0, -4.0, -3.0, 0, 0, -1.0]],
            ['A10B',   [7.0, -3.0, -3.0, 0, 0, -1.0]],
            ['A2440',  [4.0, -1.0, -1.0, 0, 0, -2.0]],
            ['A2440B', [4.0, -1.0, -2.0, 0, 0, -1.0]],
            ['A2440C', [3.0,  1.0, -1.0, 0, 0, -3.0]],
            ['A1966',  [7.0, -2.0, -2.0, 0, 0, -3.0]],
            ['A1966B', [7.0, -2.0, -3.0, 0, 0, -2.0]],
            ['A1966C', [7.0, -3.0, -3.0, 0, 0, -1.0]],
            ['A1430',  [7.0, -3.0, -2.0, 0, 0, -2.0]],
            ['A1430B', [7.0, -4.0, -2.0, 0, 0, -1.0]],
            ['A1430C', [7.0, -3.0, -3.0, 0, 0, -1.0]],
            ['A53',    [6.0, -1.0, -2.0, 0, 0, -3.0]],
            ['A53B',   [2.0,  2.0, -1.0, 0, 0, -3.0]],
            ['A53C',   [4.0, -3.0, -1.0, 0, 0,  0.0]],
            ['A258',   [2.0,  2.0, -1.0, 0, 0, -3.0]],
            ['A258B',  [6.0, -1.0, -2.0, 0, 0, -3.0]],
            ['A258C',  [4.0, -3.0, -1.0, 0, 0,  0.0]],
            ['A792',   [4.0, -3.0, -1.0, 0, 0,  0.0]],
            ['A792B',  [6.0, -1.0, -2.0, 0, 0, -3.0]],
            ['A792C',  [2.0,  2.0, -1.0, 0, 0, -3.0]]
          ]

objects.each do |elem|
  obj = elem[0]
  calc('mercury/'+obj+'.aei', elem[1], obj)
  `gnuplot output/angle.gnu > output/png/angle#{obj}.png`
  `gnuplot output/axe.gnu > output/png/axe#{obj}.png`
  `gnuplot output/multi.gnu > output/png/multi#{obj}.png`
end
