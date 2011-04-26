require 'yaml'
require 'catalog/astdys.rb'
require 'mercury/mercury6.rb'
require 'classes/functions.rb'
require 'classes/resonance_database.rb'
require 'classes/series.rb'
require 'classes/view.rb'
require 'axis/finder.rb'

if (!defined? CONFIG)
  CONFIG = YAML.load_file('config/config.yml')
end

integrate = get_command_line_argument('integrate', false)
plot      = get_command_line_argument('plot', false)
start     = get_command_line_argument('start', 1).to_i

debug = CONFIG['debug']
debug = false

Mercury6.createSmallBodyFile

axis_error = CONFIG['resonance']['axis_error']
resonances = Array.new
num_b      = CONFIG['integrator']['number_of_bodies']

# Finding possible resonances
# Create initial file for integrator

offset = start

puts "Finding asteroids and possible resonances"
num_b.times do |i|
  num = i+offset

  arr = AstDys.find_by_number(num)
  Mercury6.addSmallBody(num, arr)

  resonances.push(find_resonance_by_axis(arr[1], axis_error, true))
end 

if (integrate)
  puts "Integrating orbits"
  # Integrate orbits
  `cd mercury; ./simple_clean.sh; ./mercury6; ./element6; cd ../`
  puts "Integration is over, calculating angles"
end

# Create result files, gnuplot files and png

rdb = ResonanceDatabase.new

num_b.times do |i|
  if (resonances[i])
    if (debug)
      puts "checking resonance #{resonances[i].inspect} for #{offset+i} asteroid..."
    end
    Mercury6.calc(offset+i, resonances[i])
    has_circulation = Series.findCirculation(offset+i, 0, CONFIG['gnuplot']['x_stop'], false, true)
    if (!has_circulation)
      puts "FOUND resonance for asteroid #{offset+i} — #{resonances[i].inspect}"
      rdb.add(offset+i, resonances[i], 1)
    else
      if has_circulation[1]
        puts "MIXED type of resonance #{resonances[i].inspect} for asteroid #{offset+i} : period of circulation: #{has_circulation[2]}, percent of circulation: #{has_circulation[1]}" 
        puts "breaks = #{has_circulation[0].inspect}"
        rdb.add(offset+i, resonances[i], 3)
      else
        transport_circulation = Series.findCirculation(offset+i, 0, CONFIG['gnuplot']['x_stop'], true, true)
        if (!transport_circulation)
          puts "FOUND resonance with transport PI for asteroid #{offset+i} — #{resonances[i].inspect}"
          rdb.add(offset+i, resonances[i], 2)
        else
          puts "NOT FOUND resonance for asteroid #{offset+i}, NO libration" 
        end
      end
    end
    if (plot)
      View.createGnuplotFile(offset+i)
      tmp = %x[ gnuplot output/gnu/A#{offset+i}.gnu > output/png/A#{offset+i}.png ]
    end
  else
    if (debug)
      puts "no theoretical resonance found for #{offset+i} asteroid"
    end
  end
end