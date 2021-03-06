include Math

require 'yaml'
require 'classes/body.rb'

CONFIG = YAML.load_file('config/config.yml')
debug = CONFIG['debug']

def count_axe(resonance, jupiter, saturn, asteroid)
  asteroid.mean_motion = (-resonance[0]*jupiter.mean_motion-resonance[1]*saturn.mean_motion-resonance[3]*jupiter.longitude_of_periapsis-resonance[4]*saturn.longitude_of_periapsis)/resonance[2]
  if (asteroid.mean_motion < 0)
    return false
  end
  asteroid.axis = asteroid.axis_from_mean_motion
  #puts asteroid.axis

  eps = (jupiter.axis - asteroid.axis)/jupiter.axis
  asteroid.longitude_of_periapsis = CONFIG['constants']['k']/(2*Math::PI)*Math.sqrt(asteroid.axis/jupiter.axis)*(eps**2)*jupiter.mean_motion

  asteroid.mean_motion = (-resonance[0]*jupiter.mean_motion-resonance[1]*saturn.mean_motion-resonance[3]*jupiter.longitude_of_periapsis-resonance[4]*saturn.longitude_of_periapsis-resonance[2]*asteroid.longitude_of_periapsis)/resonance[2]
  asteroid.axis = asteroid.axis_from_mean_motion
  asteroid.axis
  #puts "axe for [#{resonance[0]}, #{resonance[1]}, #{resonance[2]}, 0, 0, #{resonance[5]}] = #{asteroid.axis}"
end

jupiter  = Body.new
saturn   = Body.new
asteroid = Body.new 

body1 = CONFIG['resonance']['bodies_numbers'][0]
body2 = CONFIG['resonance']['bodies_numbers'][1]

jupiter.axis = CONFIG['constants']['axis'][body1]
saturn.axis  = CONFIG['constants']['axis'][body2]

jupiter.mean_motion = CONFIG['constants']['mean_motion'][body1].from_sec.from_day_to_year
saturn.mean_motion  = CONFIG['constants']['mean_motion'][body2].from_sec.from_day_to_year

jupiter.longitude_of_periapsis = CONFIG['constants']['longitude_of_periapsis'][body1].from_sec.from_day_to_year
saturn.longitude_of_periapsis  = CONFIG['constants']['longitude_of_periapsis'][body2].from_sec.from_day_to_year

format = CONFIG['resonance_table']['format']

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
      tmp = count_axe(resonance, jupiter, saturn, asteroid)
      if ((diff.abs < max_order) && (asteroid.axis > 1.5) && (asteroid.axis < 5) )
        count += 1
        #puts "#{resonance[0]}; #{resonance[1]}; #{resonance[2]}; 0; 0; #{resonance[5]}; #{asteroid.axis}"
        # TeX
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

if (debug)
  puts "total = #{count}, #{count2}"
end

