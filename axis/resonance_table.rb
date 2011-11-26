include Math

require 'yaml'
require 'classes/body.rb'

CONFIG = YAML.load_file('config/config.yml')
debug = CONFIG['debug']

jupiter  = Body.new
asteroid = Body.new 

body1 = CONFIG['resonance']['bodies_numbers'][0]
body2 = CONFIG['resonance']['bodies_numbers'][1]

jupiter.axis = CONFIG['constants']['axis'][body1]
jupiter.mean_motion = CONFIG['constants']['mean_motion'][body1].from_sec.from_day_to_year
jupiter.longitude_of_periapsis = CONFIG['constants']['longitude_of_periapsis'][body1].from_sec.from_day_to_year

mass_j = CONFIG['constants']['planets'][body1].to_f

format = CONFIG['resonance_table']['format']

# resonance = [5, -2, -2, 0, 0, 1]

max_order = 11
count  = 0

for i in 1..max_order
  for j in 1..max_order
    next if (i<j)
    next if (i.gcd(j) > 1)
    diff = (i - j).to_i
    resonance = [i,-j,0,-diff]
    #next if (diff.abs > max_order)
    asteroid.axis = jupiter.axis*(((j.to_f/i.to_f)**(2.0))**(1.0/3))
    if (asteroid.axis != 0)
      if (format == 'tex')
        printf("%d & %d & %d & %d & %2.4f \\\\ \n", resonance[0], resonance[1], resonance[2], resonance[3], asteroid.axis)
      elsif (format == 'simple')
        printf("%d %d %d %d %2.4f \n", resonance[0], resonance[1], resonance[2], resonance[3], asteroid.axis)
      else
        printf("%d %d %d %d %2.4f \n", resonance[0], resonance[1], resonance[2], resonance[3], asteroid.axis)
      end
    end
  end
end

if (debug)
end

