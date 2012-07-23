require 'config/config.rb'
require 'classes/body.rb'

class Resonance
  
  attr_accessor :resonance
  
  def initialize(resonance = false)
    @resonance = resonance
  end
  
  def self.resonant_axis(resonance, jupiter, saturn, asteroid)
    asteroid.mean_motion = (-resonance[0]*jupiter.mean_motion-resonance[1]*saturn.mean_motion-resonance[3]*jupiter.longitude_of_periapsis-resonance[4]*saturn.longitude_of_periapsis)/resonance[2]
    return false if (asteroid.mean_motion < 0)
    asteroid.a_from_n
    
    eps = (jupiter.axis - asteroid.axis)/jupiter.axis
    asteroid.longitude_of_periapsis = CONFIG['constants']['k']/(2*Math::PI)*Math.sqrt(asteroid.axis/jupiter.axis)*(eps**2)*jupiter.mean_motion

    asteroid.mean_motion = (-resonance[0]*jupiter.mean_motion-resonance[1]*saturn.mean_motion-resonance[3]*jupiter.longitude_of_periapsis-resonance[4]*saturn.longitude_of_periapsis-resonance[2]*asteroid.longitude_of_periapsis)/resonance[2]
    asteroid.a_from_n
  end
  
  def self.table
    jupiter  = Body.new
    saturn   = Body.new
    asteroid = Body.new 

    body1 = CONFIG['resonance']['bodies_numbers'][0]
    body2 = CONFIG['resonance']['bodies_numbers'][1]

    jupiter.axis = CONFIG['constants']['axis'][body1]
    saturn.axis  = CONFIG['constants']['axis'][body2]

    jupiter.mean_motion = CONFIG['constants']['mean_motion'][body1].from_sec.from_day_to_year
    p jupiter.mean_motion
    saturn.mean_motion  = CONFIG['constants']['mean_motion'][body2].from_sec.from_day_to_year

    jupiter.longitude_of_periapsis = CONFIG['constants']['longitude_of_periapsis'][body1].from_sec.from_day_to_year
    saturn.longitude_of_periapsis  = CONFIG['constants']['longitude_of_periapsis'][body2].from_sec.from_day_to_year

    format = CONFIG['resonances']['format']

    # resonance = [5, -2, -2, 0, 0, 1]

    max_order = 7
    count  = 0
    count2 = 0

    for i in 1..8
      for j in -max_order..max_order
        for k in -max_order..max_order
          diff = (0.0 - i - j - k).to_i
          resonance = [i,j,k,0,0,diff]
          next if ((i == 0) || (j == 0) || (k == 0))
          next if (diff.abs > max_order)
          tmp = self.resonant_axis(resonance, jupiter, saturn, asteroid)
          if ((diff.abs < max_order) && (asteroid.axis > 1.5) && (asteroid.axis < 5) )
            count += 1
            if (asteroid.axis != 0)
              if (format == 'tex')
                printf("%d & %d & %d & %d & %2.4f \\\\ \n", resonance[0], resonance[1], resonance[2], resonance[5], asteroid.axis)
              elsif (format == 'simple')
                printf("%d %d %d 0 0 %d %2.4f \n", resonance[0], resonance[1], resonance[2], resonance[5], asteroid.axis)
              else
                printf("%d %d %d 0 0 %d %2.4f \n", resonance[0], resonance[1], resonance[2], resonance[5], asteroid.axis)
              end
            end
          end
        end
      end
    end
    puts "total = #{count}, #{count2}" if CONFIG['debug']
  end
  
  def self.find(axis, error = 0.0001, just_one = true)
    r_file = CONFIG['resonances']['file']

    res       = []
    min_array = [] # array for errors 

    File.open(r_file).each do |line|
      arr = line.split(' ').map{|x| x.to_f}
      if ((arr[6] - axis).abs <= error )
        res.push(arr)
        min_array.push(arr[6] - axis)
      end
    end

    if (!just_one && !res.empty?)
      res
    elsif (!res.empty?)
      min = min_array.min
      res[min]
    else
      false
    end
  end
  
  def self.to_s
    @resonance.inspect
  end
  
  def self.from_s(s)
    s.sub('[', '').sub(']', '').split(',').each_with_index.map{|value, index| (index < 6) ? value.strip.to_i : value.strip.to_f}
  end
  
  def ==(resonance)
    min = [resonance.size, @resonance.size].min
    @resonance.each_with_index do |value, index|
      return false if (value != resonance[index] && index < min)
    end
    true
  end
  
  def equals?(s)
    resonance = s.sub('[', '').sub(']', '').split(',').each_with_index.map{|value, index| (index < 6) ? value.strip.to_i : value.strip.to_f}
    self == resonance
  end
  
  def self.gcd?(r)
    r = r.each.map{|elem| elem.to_i.abs }
    for i in 2..3
      return true if ((r[0]%i==0) && (r[1]%i==0) && ((r[2]%i==0)))
    end
    false
  end  
  
end
