# Extract integrator files from archive
require 'yaml'
require 'catalog/astdys.rb'
require 'mercury/mercury6.rb'
require 'classes/functions.rb'
require 'classes/resonance_archive.rb'
require 'classes/resonance_database.rb'
require 'classes/series.rb'
require 'classes/view.rb'
require 'axis/finder.rb'

start  = get_command_line_argument('start', false)
stop   = get_command_line_argument('stop',  false)

start = start.to_i
stop  = stop.to_i

num_b = CONFIG['integrator']['number_of_bodies']

if (!stop)
  stop = start + num_b
end

axis_error = CONFIG['resonance']['axis_error']
resonances = Array.new
num_b      = CONFIG['integrator']['number_of_bodies']

delta = stop - start

puts "Finding asteroids and possible resonances"
delta.times do |i|
  num = start + i
  arr = AstDys.find_by_number(num)
  resonances.push(find_resonance_by_axis(arr[1], axis_error, false))
end 

number_of_steps = (stop-start)-1

rdb = ResonanceDatabase.new('full.db')

# Extract from archive data
#is_extracted = ResonanceArchive.extract(start, 1)

for i in 0..number_of_steps
  asteroid_num = start + i
  if (resonances[i])
    resonances[i].each do |resonance|
      puts "Plot for asteroid #{asteroid_num}"
      Mercury6.calc(asteroid_num, resonance)
      has_circulation = Series.findCirculation(asteroid_num, 0, CONFIG['gnuplot']['x_stop'], false, true)
      hash_r = hash_resonance(resonance)
      if (has_circulation)
        max = Series.max(has_circulation[0])
        puts "% = #{has_circulation[1]}%, medium period = #{has_circulation[2]}, max = #{max}, resonance = #{resonance.inspect}"
        s = asteroid_num.to_s+';'+resonance.inspect+';2'+has_circulation[2].to_s+';'+max.to_s
        rdb.addString(s)
      else
        puts "pure resonance"
        s = asteroid_num.to_s+';'+resonance.inspect+';1'
        rdb.addString(s)
      end
      View.createGnuplotFile(asteroid_num)
      tmp = %x[ gnuplot output/gnu/A#{asteroid_num}.gnu > output/png_res/A#{asteroid_num}-#{hash_r}.png ]
    end
  end
end

